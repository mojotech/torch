defmodule Torch.Pagination do
  @moduledoc """
  Handles Torch pagination queries and filtering.

  ## Usage

  When using the `torch.gen.html` generators, `Torch.Pagination` will
  automatically be added to your generated context module in the following
  way (using a module called Comment as an example):

      defmodule MyApp.MyModule do
        use Torch.Pagination,
          repo: MyApp.Repo,
          model: MyApp.MyContext.Comment,
          name: :comments
      end

  The following Torch context methods will be created by using `Torch.Pagination`:

    * public `paginate_*/1`
    * public `filter_config/1`
    * private `do_paginate_*/2`

  Customization of `filter_config/1` is available as this function is defined as `defoverridable` for
  when you prefer to customize the Filtrex filtering configuration.

  ## Required configuration options

    * `:repo` - the application's Ecto.Repo module (required)
    * `:model` - the application's schema module (required)
    * `:name` - the plural name of the collection that needs pagination (required)

  ## Optional configuration options

  Additionaly, the following parameters are also supported and can be manually
  configured and supplied to the `use Torch.Pagination` call:

    * `:page_size` - (default: 15) controls how many items are returned per page
    * `:pagination_size` - (default: 5) controls how many pagination links are displayed in the UI

  You may also configure `page_size` and `pagination_distance` on app level for app-wide
  defaults when configuring `Torch` in the application `config/config.exs` file:

    config :torch,
      otp_app: :my_app,
      page_size: 20,
      pagination_distance: 3

  ## Manual Pagination

  If, for some reason, the default `Torch.Pagination` method results do not support your application's
  needs, you may manually implement `paginate_*/1` yourself in your context module. Your customized
  `paginate_*` must return one of the following tuples (typespec `Torch.Pagination.t()`):

    * `{:ok, Torch.Pagination.page()}`
    * `{:error, any}`

  """
  @moduledoc since: "5.1.0"

  @type page() :: %{
          atom => list(any()),
          page_number: non_neg_integer(),
          page_size: non_neg_integer(),
          total_pages: non_neg_integer(),
          total_entries: non_neg_integer(),
          distance: non_neg_integer(),
          sort_field: String.t(),
          sort_direction: String.t()
        }
  @type filter_config() :: [Filtrex.Type.Config.t()]
  @type t() :: {:ok, page()} | {:error | any}

  import Ecto.Query, only: [order_by: 2]

  defmacro __using__(opts) do
    {:__aliases__, _, module_name} = Keyword.fetch!(opts, :model)
    {:__aliases__, _, repo_name} = Keyword.fetch!(opts, :repo)
    name = Keyword.fetch!(opts, :name)

    repo = Module.concat(repo_name)
    model = Module.concat(module_name)
    page_size = Keyword.get(opts, :page_size, Application.get_env(:torch, :page_size, 15))

    pagination_distance =
      Keyword.get(
        opts,
        :pagination_distance,
        Application.get_env(:torch, :pagination_distance, 5)
      )

    singular = model |> Module.split() |> List.last() |> Phoenix.Naming.underscore()
    schema_attrs = model.__schema__(:query_fields)
    schema_filter_config = build_filter_config(model, schema_attrs)

    quote(generated: true) do
      def unquote(:"paginate_#{name}")(params \\ %{}) do
        params =
          params
          |> Torch.Helpers.strip_unset_booleans(
            unquote(singular),
            Enum.reduce(
              unquote(schema_attrs),
              [],
              &if(unquote(model).__schema__(:type, &1) == :boolean,
                do: [&1 | &2],
                else: &2
              )
            )
          )
          |> Map.put_new("sort_direction", "desc")
          |> Map.put_new("sort_field", "inserted_at")

        {:ok, sort_direction} = Map.fetch(params, "sort_direction")
        {:ok, sort_field} = Map.fetch(params, "sort_field")

        with {:ok, filter} <-
               Filtrex.parse_params(
                 filter_config(unquote(:"#{name}")),
                 Map.get(params, unquote(singular), %{})
               ),
             %Scrivener.Page{} = page <- unquote(:"do_paginate_#{name}")(filter, params) do
          {
            :ok,
            %{
              unquote(name) => page.entries,
              page_number: page.page_number,
              page_size: page.page_size,
              total_pages: page.total_pages,
              total_entries: page.total_entries,
              distance: unquote(pagination_distance),
              sort_field: sort_field,
              sort_direction: sort_direction
            }
          }
        else
          {:error, error} -> {:error, error}
          error -> {:error, error}
        end
      end

      def filter_config(unquote(:"#{name}")) do
        unquote(Macro.escape(schema_filter_config))
      end

      defp unquote(:"do_paginate_#{name}")(filter, params) do
        pagination = [page_size: unquote(page_size)]

        unquote(model)
        |> Filtrex.query(filter)
        |> order_by(^Torch.Helpers.sort(params))
        |> Torch.Helpers.paginate(unquote(repo), params, pagination)
      end
    end
  end

  defp build_filter_config(_model, []), do: []

  defp build_filter_config(model, schema_attrs) do
    schema_attrs
    |> Enum.reduce(
      Map.from_keys(~w(date number text boolean id binary_id)a, []),
      &collect_attributes_by_type(&1, model.__schema__(:type, &1), &2)
    )
    |> Enum.reduce([], &build_filtrex_configs/2)
  end

  # TODO: Handle `:array`, `:enum`, and `:datetime` field types
  defp collect_attributes_by_type(_attr, {:array, _}, collection), do: collection

  defp collect_attributes_by_type(_attr, {:paremeterized, Ecto.Enum, _}, collection),
    do: collection

  defp collect_attributes_by_type(_attr, attr_type, collection) when is_tuple(attr_type),
    do: collection

  defp collect_attributes_by_type(attr, attr_type, collection)
       when attr_type in [:integer, :number, :id] do
    Map.update(collection, :number, [attr], fn curr_value -> [attr | curr_value] end)
  end

  defp collect_attributes_by_type(attr, attr_type, collection)
       when attr_type in [:naive_datetime, :utc_datetime, :datetime, :date] do
    Map.update(collection, :date, [attr], fn curr_value -> [attr | curr_value] end)
  end

  defp collect_attributes_by_type(attr, :boolean, collection) do
    Map.update(collection, :boolean, [attr], fn curr_value -> [attr | curr_value] end)
  end

  defp collect_attributes_by_type(attr, attr_type, collection)
       when attr_type in [:string, :text] do
    Map.update(collection, :text, [attr], fn curr_value -> [attr | curr_value] end)
  end

  defp collect_attributes_by_type(attr, :binary_id, collection) do
    Map.update(collection, :binary_id, [attr], fn curr_value -> [attr | curr_value] end)
  end

  defp collect_attributes_by_type(_attr, _attr_type, collection), do: collection

  defp build_filtrex_configs({:date, attrs_list}, configs),
    do: add_filtrex_config(configs, :date, attrs_list, %{format: "{YYYY}-{0M}-{0D}"})

  defp build_filtrex_configs({:number, attrs_list}, configs),
    do: add_filtrex_config(configs, :number, attrs_list, %{allow_decimal: false})

  defp build_filtrex_configs({:text, attrs_list}, configs),
    do: add_filtrex_config(configs, :text, attrs_list)

  defp build_filtrex_configs({:boolean, attrs_list}, configs),
    do: add_filtrex_config(configs, :boolean, attrs_list)

  defp build_filtrex_configs({:binary_id, attrs_list}, configs),
    do: add_filtrex_config(configs, :binary_id, attrs_list)

  defp build_filtrex_configs(_, configs), do: configs

  defp add_filtrex_config(c, ft, fk), do: add_filtrex_config(c, ft, fk, %{})

  defp add_filtrex_config(configs, filter_type, filter_keys, opts) do
    [
      %Filtrex.Type.Config{
        keys: Enum.map(filter_keys, &to_string/1),
        options: opts,
        type: filter_type
      }
      | configs
    ]
  end
end

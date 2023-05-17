defmodule Torch.Helpers do
  @moduledoc """
  Provides helper functions for Torch-generated controllers.
  """

  @type params :: map

  @doc """
  Determines how the query for an index action should be sorted.

  Relies on the `"sort_field"` and `"sort_direction"` parameters to be passed.
  By default, it sorts by `:id` in ascending order.

  ## Examples

      iex> sort(%{"sort_field" => "name", "sort_direction" => "desc"})
      {:desc, :name}

      iex> sort(%{})
      {:asc, :id}

  In a query pipeline, use in conjunction with `Ecto.Query.order_by/3`:

      order_by(query, ^sort(params))

  """
  @spec sort(params) :: {atom, atom} | {:asc, :id}
  def sort(params)

  def sort(%{"sort_field" => field, "sort_direction" => direction}) do
    {String.to_atom(direction), String.to_atom(field)}
  end

  def sort(_other) do
    {:asc, :id}
  end

  @doc """
  Paginates a given `Ecto.Queryable` using Scrivener.

  This is a very thin wrapper around `Scrivener.paginate/2`, so see [the Scrivener
  Ecto documentation](https://github.com/drewolson/scrivener_ecto) for more details.

  ## Parameters

  - `query`: An `Ecto.Queryable` to paginate.
  - `repo`: Your Repo module.
  - `params`: Parameters from your `conn`. For example `%{"page" => 1}`.
  - `settings`: A list of settings for Scrivener, including `:page_size`.

  ## Examples

      paginate(query, Repo, params, [page_size: 15])
      # => %Scrivener.Page{...}
  """
  @spec paginate(Ecto.Queryable.t(), Ecto.Repo.t(), params, Keyword.t()) :: Scrivener.Page.t()
  def paginate(query, repo, params, settings \\ [page_size: 10]) do
    Scrivener.paginate(query, Scrivener.Config.new(repo, settings, params))
  end

  @doc """
  Removes any "un-set" boolean parameters from the filter params list.

  Due to the nature of boolean params (on/off) it becomes hard to include
  the "filter on true" and "filter on false" states while also including a
  third option of "don't filter at all" on this boolean argument.  Since the
  parameter is always sent in the filter form (due to the checkbox).

  We need a way to encode 3 states for a boolean field (on, off, any|ignore).

  This function takes a list of boolean field names, and will remove from the
  params argument, any matching boolean fields whose current value is set to
  "any" (which is the default placeholder Torch UI uses to signify this third
  boolean state).

  ## Examples

      iex> strip_unset_booleans(%{}, "post", [])
      %{}

      iex> strip_unset_booleans(%{"post" => %{"title_contains" => "foo"}}, "post", [])
      %{"post" => %{"title_contains" => "foo"}}

      iex> strip_unset_booleans(%{"post" => %{"title_contains" => "foo"}}, "post", [:title])
      %{"post" => %{"title_contains" => "foo"}}

      iex> strip_unset_booleans(%{"post" => %{"title_equals" => "true"}}, "post", [:title])
      %{"post" => %{"title_equals" => "true"}}

      iex> strip_unset_booleans(%{"post" => %{"title_equals" => "any"}}, "post", [:title])
      %{"post" => %{}}

      iex> strip_unset_booleans(%{"post" => %{"name_contains" => "foo", "title_equals" => "any"}}, "post", [:title])
      %{"post" => %{"name_contains" => "foo"}}

      iex> strip_unset_booleans(%{"post" => %{"name_equals" => "any", "title_equals" => "any"}}, "post", [:title, :name])
      %{"post" => %{}}

      iex> strip_unset_booleans(%{"post" => %{"name_equals" => "any", "title_equals" => "any", "surname_equals" => "bar"}}, "post", [:title, :name])
      %{"post" => %{"surname_equals" => "bar"}}

  """
  @spec strip_unset_booleans(params, binary, [atom]) :: params
  def strip_unset_booleans(params, _, []), do: params

  def strip_unset_booleans(params, schema_name, [bool_field | rest] = bool_fields)
      when is_list(bool_fields) and is_binary(schema_name) do
    params
    |> strip_unset_boolean(schema_name, bool_field)
    |> strip_unset_booleans(schema_name, rest)
  end

  defp strip_unset_boolean(params, schema_name, bool_field) when is_atom(bool_field) do
    strip_unset_boolean(params, schema_name, to_string(bool_field))
  end

  defp strip_unset_boolean(params, schema_name, bool_field) when is_binary(bool_field) do
    field_name = bool_field <> "_equals"

    case Map.fetch(params, schema_name) do
      {:ok, schema_params} ->
        case Map.get(schema_params, field_name) do
          nil -> params
          "any" -> Map.put(params, schema_name, Map.drop(schema_params, [field_name]))
          _v -> params
        end

      :error ->
        params
    end
  end

  @doc """
  Takes the controller action name and appends it to the torch- prefix.

  ## Example

      iex> body_classes(%Plug.Conn{private: %{phoenix_action: :create}})
      "torch-create"

      iex> body_classes(%Plug.Conn{private: %{phoenix_action: :custom_action}})
      "torch-custom-action"
  """
  @doc since: "5.0.0"
  @spec body_classes(Plug.Conn.t()) :: String.t()
  def body_classes(conn) do
    conn
    |> action_name()
    |> add_torch_prefix()
    |> String.trim()
  end

  defp action_name(conn) do
    conn
    |> Phoenix.Controller.action_name()
    |> Atom.to_string()
    |> String.replace("_", "-")
  end

  defp add_torch_prefix(str), do: "torch-#{str}"
end

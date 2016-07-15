defmodule Mix.Tasks.Torch.Gen do
  @moduledoc """
  Generates a Torch admin section for a given Ecto Schema.
  The following parameters should be passed in order, without flags.

  ### Format

  The first argument is the templating language that the generated templates
  should use. Either **"eex"** or **"slim"**.

  ### Namespace

  The Elixir namespace you want all the code to be generated within. For example,
  if your app is named `MyApp`, and you want to put all the admin code under
  `MyApp.Admin`, you'd pass in **"Admin"** here.

  ### Singular Schema Name

  The singular and capitalized version of the schema name.
  For example, **"Post"**.

  ### Plural Schema Name

  The snake case and pluralized version of the schema name.
  For example, **"posts"**.

  ### Schema Fields

  Space separated fields and types, describing which fields of the schema you
  want to appear in the generated tables and forms. These are in the format
  `field_name:type`.

  - `field_name:string`: Torch will use a
    [text_input](https://hexdocs.pm/phoenix_html/Phoenix.HTML.Form.html#text_input/3)
    to represent the field.

  - `field_name:text`: Torch will use a
    [textarea](https://hexdocs.pm/phoenix_html/Phoenix.HTML.Form.html#textarea/3)
    to represent the field.

  - `field_name:(integer|float|decimal)`: Torch will use a
    [number_input](https://hexdocs.pm/phoenix_html/Phoenix.HTML.Form.html#number_input/3)
    to represent the field.

  - `field_name:boolean`: Torch will use a
    [select](https://hexdocs.pm/phoenix_html/Phoenix.HTML.Form.html#select/3)
    with the options "Choose one", "True" and "False" to represent the field.

  - `field_name:date`: Torch will use a Pikaday datepicker input to represent
    the field. If the field name is `inserted_at` or `updated_at`, the field will
    only be displayed in the filter sidebar, not the new/edit forms.

  - `field_name:references:assoc,assocs:primary_key,display_name`: Torch will set up
    filtering and form fields for a `belongs_to` relationship on the schema. For example,
    if your `Post` schema looked like this:

          schema "posts" do
            belongs_to :category, Example.Category

            # ...
          end

    You could use the following `references` field in your `mix torch.gen` call:

          category_id:references:category,categories:id,name

    This would tell Torch that:

        - The `Post` schema has a `belongs_to` relationship on `category_id`.

        - The relationship is called `:category`.

        - The plural name of the relationship is "categories".

        - The `<select>` box it generates should use the category `id` field as the
          value and the category `name` field as the value.

  ## Example

      mix torch.gen eex Admin Post posts category_id:references:category,categories:id,name title:string body:text inserted_at:date
  """

  use Mix.Task

  @doc false
  def run(args) do
    Mix.Task.run("app.start", [])
    {_opts, [format, namespace, singular, plural | attrs], _} = OptionParser.parse(args, switches: [])

    namespace_underscore = Macro.underscore(namespace)
    binding = Mix.Torch.inflect(namespace, singular)
    path = namespace_underscore <> "/" <> binding[:path]
    attrs = Mix.Torch.attrs(attrs)
    binding = binding ++ [plural: plural,
                          attrs: attrs,
                          configs: configs(attrs),
                          namespace: namespace,
                          namespace_underscore: namespace_underscore,
                          inputs: inputs(format, attrs),
                          assoc_plugs: assoc_plugs(attrs),
                          assoc_plug_definitions: assoc_plug_definitions(binding, attrs)]


    Mix.Torch.copy_from [:torch], "priv/templates/#{format}", "", binding, [
      {:eex, "index.#{format}.eex", "web/templates/#{path}/index.html.#{format}"},
      {:eex, "edit.#{format}.eex", "web/templates/#{path}/edit.html.#{format}"},
      {:eex, "new.#{format}.eex", "web/templates/#{path}/new.html.#{format}"},
      {:eex, "_form.#{format}.eex", "web/templates/#{path}/_form.html.#{format}"},
      {:eex, "_filters.#{format}.eex", "web/templates/#{path}/_filters.html.#{format}"}
    ]

    Mix.Torch.copy_from [:torch], "priv/templates/elixir", "", binding, [
      {:eex, "controller.ex", "web/controllers/#{path}_controller.ex"},
      {:eex, "view.ex", "web/views/#{path}_view.ex"}
    ]

    Mix.shell.info """
    Success!

    You should now add a route to the new controller to your `router.ex`, within the `:admin` scope:

        scope "/admin", #{Mix.Torch.base}.Admin, as: :admin do
          pipe_through :browser

          #{IO.ANSI.green}resources "/#{binding[:plural]}", #{binding[:alias]}Controller#{IO.ANSI.reset}
        end

    And add the following link in your `layout/admin.html.#{format}` navigation:

    #{help(format, binding)}
    """
  end

  defp help("eex", binding) do
    """
        <header id="main-header">
          <nav>
            <h1>Torch Admin</h1>
            <ul>
              #{IO.ANSI.green}<li><%= Torch.NavigationView.nav_link @conn, "#{String.capitalize(binding[:plural])}", #{ binding[:namespace_underscore]}_#{binding[:singular]}_path(@conn, :index) %></li>#{IO.ANSI.reset}
            </ul>
          </nav>
        </header>
    """
  end

  defp help("slim", binding) do
    """
        header#main-header
          nav
            h1 Torch Admin
            ul
              #{IO.ANSI.green}li= Torch.NavigationView.nav_link @conn, "#{String.capitalize(binding[:plural])}", #{ binding[:namespace_underscore]}_#{binding[:singular]}_path(@conn, :index)#{IO.ANSI.reset}
    """
  end

  defp inputs("eex", attrs) do
    inputs = inputs("slim", attrs)
    for {label, input, error} <- inputs do
      {~s(<%#{label} %>), ~s(<%#{input} %>), ~s(<%#{error} %>)}
    end
  end

  defp inputs("slim", attrs) do
    attrs = Enum.reject(attrs, fn({key, _type}) -> key in [:inserted_at, :updated_at] end)
    Enum.map attrs, fn
      {_, {:array, _}} ->
        {nil, nil, nil}
      {key, {:references, data}} ->
        {label(data[:assoc_singular]), ~s(= select f, #{inspect(key)}, @#{data[:assoc_plural]}, prompt: "Choose one"), error(key)}
      {key, :file} ->
        {label(key), ~s(= file_input f, #{inspect(key)}), error(key)}
      {key, :integer}    ->
        {label(key), ~s(= number_input f, #{inspect(key)}), error(key)}
      {key, :float}      ->
        {label(key), ~s(= number_input f, #{inspect(key)}, step: "any"), error(key)}
      {key, :decimal}    ->
        {label(key), ~s(= number_input f, #{inspect(key)}, step: "any"), error(key)}
      {key, :boolean}    ->
        {label(key), ~s(= select f, #{inspect(key)}, [{"True", true}, {"False", false}], prompt: "Choose one"), error(key)}
      {key, :text}       ->
        {label(key), ~s(= textarea f, #{inspect(key)}), error(key)}
      {key, :date}       ->
        {label(key), ~s(= date_select f, #{inspect(key)}), error(key)}
      {key, :time}       ->
        {label(key), ~s(= time_select f, #{inspect(key)}), error(key)}
      {key, :datetime}   ->
        {label(key), ~s(= datetime_select f, #{inspect(key)}), error(key)}
      {key, _}           ->
        {label(key), ~s(= text_input f, #{inspect(key)}), error(key)}
    end
  end

  defp assoc_plugs(attrs) do
    for {_key, {:references, data}} <- attrs do
      "plug :assign_#{data[:assoc_plural]}"
    end
  end

  defp assoc_plug_definitions(binding, attrs) do
    model = Module.concat([Elixir, binding[:base], binding[:scoped]])

    for {_key, {:references, data}} <- attrs do
      assoc = model.__schema__(:association, data[:assoc_singular]).queryable
      """
        defp assign_#{data[:assoc_plural]}(conn, _opts) do
          #{data[:assoc_plural]} =
            #{inspect(assoc)}
            |> Repo.all
            |> Enum.map(&({&1.#{data[:display_name]}, &1.#{data[:primary_key]}}))
          assign(conn, :#{data[:assoc_plural]}, #{data[:assoc_plural]})
        end
      """
    end
  end

  defp configs(attrs) do
    attrs
    |> Enum.group_by(&group_key/1, &elem(&1, 0))
    |> Enum.map(&config/1)
    |> Enum.reject(&is_nil/1)
  end

  defp config({:text, fields}) do
    "%Config{type: :text, keys: ~w(#{Enum.join(fields, " ")})}"
  end
  defp config({:date, fields}) do
    "%Config{type: :date, keys: ~w(#{Enum.join(fields, " ")}), options: %{format: \"{YYYY}-{0M}-{0D}\"}}"
  end
  defp config({:boolean, fields}) do
    "%Config{type: :boolean, keys: ~w(#{Enum.join(fields, " ")})}"
  end
  defp config({{:references, _}, fields}) do
    "%Config{type: :number, keys: ~w(#{Enum.join(fields, " ")})}"
  end
  defp config(_), do: nil

  defp group_key({_key, :string}), do: :text
  defp group_key({_key, type}), do: type

  defp label(key) do
    ~s(= label f, #{inspect(key)})
  end

  defp error(field) do
    ~s(= error_tag f, #{inspect(field)})
  end
end

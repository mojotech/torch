defmodule Mix.Torch do
  @moduledoc false

  alias Torch.Config

  def parse_config!(task, args) do
    {opts, _, _} = OptionParser.parse(args, switches: [app: :string])

    otp_app = opts[:app] || Config.otp_app()

    unless otp_app do
      Mix.raise("""
      You need to specify an OTP app to generate files within. Either
      configure it as shown below or pass it in via the `--app` option.

          config :torch,
            otp_app: :my_app

          # Alternatively
          mix #{task} --app my_app
      """)
    end

    %{otp_app: otp_app, format: "heex"}
  end

  def ensure_phoenix_is_loaded!(mix_task \\ "task") do
    case Application.load(:phoenix) do
      :ok ->
        :ok

      {:error, {:already_loaded, :phoenix}} ->
        :ok

      {:error, reason} ->
        Mix.raise("mix #{mix_task} could not complete due to Phoenix not being loaded: #{reason}")
    end
  end

  def copy_from(source_dir, mapping) when is_list(mapping) do
    for {source_file_path, target_file_path} <- mapping do
      contents =
        [Application.app_dir(:torch), source_dir, source_file_path]
        |> Path.join()
        |> File.read!()

      Mix.Generator.create_file(target_file_path, contents)
    end
  end

  @doc """
  Copy templates files depending of the executed mix task.

  Torch currently only supports HEEX templates.
  """

  def inject_templates(task),
    do: inject_templates(task, to_string(Application.spec(:phoenix, :vsn)))

  def inject_templates("phx.gen.context", _vsn) do
    copy_from("priv/templates/phx.gen.context", [
      {"access_no_schema.ex", "priv/templates/phx.gen.context/access_no_schema.ex"},
      {"context.ex", "priv/templates/phx.gen.context/context.ex"},
      {"schema_access.ex", "priv/templates/phx.gen.context/schema_access.ex"},
      {"test_cases.exs", "priv/templates/phx.gen.context/test_cases.exs"},
      {"context_test.exs", "priv/templates/phx.gen.context/context_test.exs"}
    ])
  end

  def inject_templates("phx.gen.html", phx_version) do
    copy_from("priv/templates/phx.gen.html", [
      {versioned_template("edit", phx_version), "priv/templates/phx.gen.html/edit.html.heex"},
      {"resource_form.html.heex", "priv/templates/phx.gen.html/resource_form.html.heex"},
      {"index.html.heex", "priv/templates/phx.gen.html/index.html.heex"},
      {versioned_template("new", phx_version), "priv/templates/phx.gen.html/new.html.heex"},
      {"show.html.heex", "priv/templates/phx.gen.html/show.html.heex"},
      {"controller_test.exs", "priv/templates/phx.gen.html/controller_test.exs"},
      {"controller.ex", "priv/templates/phx.gen.html/controller.ex"},
      {"html.ex", "priv/templates/phx.gen.html/html.ex"}
    ])
  end

  def backup_project_templates(mix_task_name) do
    File.rename("priv/templates/#{mix_task_name}", "priv/templates/#{mix_task_name}_backup")
  end

  def restore_project_templates(mix_task_name) do
    File.rename("priv/templates/#{mix_task_name}_backup", "priv/templates/#{mix_task_name}")
  end

  def remove_templates(template_dir) do
    File.rm_rf("priv/templates/#{template_dir}/")
  end

  def torch_inputs(%Mix.Phoenix.Schema{} = schema) do
    Enum.map(schema.attrs, fn
      {_, {:references, _}} ->
        ~s"""
        <span>Association references are not yet supported</span>
        """

      {key, :integer} ->
        ~s"""
        <.torch_input label="#{label(key)}" field={f[#{inspect(key)}]} type="number" />
        """

      {key, :float} ->
        ~s"""
        <.torch_input label="#{label(key)}" field={f[#{inspect(key)}]} type="number" />
        """

      {key, :decimal} ->
        ~s"""
        <.torch_input label="#{label(key)}" field={f[#{inspect(key)}]} type="number" />
        """

      {key, :boolean} ->
        ~s"""
        <.torch_input label="#{label(key)}" field={f[#{inspect(key)}]} type="checkbox" />
        """

      {key, :text} ->
        ~s"""
        <.torch_input label="#{label(key)}" field={f[#{inspect(key)}]} type="textarea" />
        """

      {key, :string} ->
        ~s"""
        <.torch_input label="#{label(key)}" field={f[#{inspect(key)}]} type="string" />
        """

      {key, :date} ->
        ~s"""
        <.torch_input label="#{label(key)}" field={f[#{inspect(key)}]} type="date" />
        """

      {key, :time} ->
        ~s"""
        <.torch_input label="#{label(key)}" field={f[#{inspect(key)}]} type="time" />
        """

      {key, :utc_datetime} ->
        ~s"""
        <.torch_input label="#{label(key)}" field={f[#{inspect(key)}]} type="datetime-local" />
        """

      {key, :naive_datetime} ->
        ~s"""
        <.torch_input label="#{label(key)}" field={f[#{inspect(key)}]} type="datetime-local" />
        """

      {key, {:array, _} = type} ->
        ~s"""
        <.torch_input
          field={f[#{inspect(key)}]}
          type="select"
          multiple
          label="#{label(key)}"
          options={#{inspect(default_options(type))}}
        />
        """

      {key, {:enum, _}} ->
        ~s"""
        <.torch_input
          field={f[#{inspect(key)}]}
          type="select"
          label="#{label(key)}"
          prompt="Choose a value"
          options={Ecto.Enum.values(#{inspect(schema.module)}, #{inspect(key)})}
        />
        """

      {key, type} ->
        ~s"""
        <.torch_input label="#{label(key)}" field={f[#{inspect(key)}]} type="#{type}" />
        """
    end)
  end

  @doc false
  def indent_inputs(inputs), do: indent_inputs(inputs, 2)

  def indent_inputs(inputs, col_padding) do
    columns = String.duplicate(" ", col_padding)

    inputs
    |> Enum.map(fn input ->
      lines = input |> String.split("\n") |> Enum.reject(&(&1 == ""))

      case lines do
        [line] ->
          [columns, line]

        [first_line | rest] ->
          rest = Enum.map_join(rest, "\n", &(columns <> &1))
          [columns, first_line, "\n", rest]
      end
    end)
    |> Enum.intersperse("\n")
  end

  defp default_options({:array, :string}),
    do: Enum.map([1, 2], &{"Option #{&1}", "option#{&1}"})

  defp default_options({:array, :integer}),
    do: Enum.map([1, 2], &{"#{&1}", &1})

  defp default_options({:array, _}), do: []

  defp label(key), do: Phoenix.Naming.humanize(to_string(key))

  defp versioned_template(template_name, phx_version) when template_name in ["new", "edit"] do
    if Version.match?(phx_version, "< 1.7.1") do
      "#{template_name}_1_7_0.html.heex"
    else
      "#{template_name}.html.heex"
    end
  end

  defp versioned_template(template_name, _phx_version), do: "#{template_name}.html.heex"
end

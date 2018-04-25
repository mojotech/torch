defmodule Mix.Torch do
  @moduledoc false

  alias Torch.Config

  @doc false
  def parse_config!(task, args) do
    {opts, _, _} = OptionParser.parse(args, switches: [format: :string, app: :string])

    format = opts[:format] || Config.template_format()
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

    unless format in ["eex", "slim"] do
      Mix.raise("""
      Template format is invalid: #{inspect(format)}. Either configure it as
      shown below or pass it via the `--format` option.

          config :torch,
            template_format: :slim

          # Alternatively
          mix #{task} --format slim

      Supported formats: eex, slim
      """)
    end

    %{otp_app: otp_app, format: format}
  end

  @doc """
  Copies files from source dir to target dir
  according to the given map.

  Files are evaluated against EEx according to
  the given binding.
  """
  def copy_from(apps, source_dir, target_dir, _binding, mapping) when is_list(mapping) do
    roots = Enum.map(apps, &to_app_source(&1, source_dir))

    for {_format, source_file_path, target_file_path} <- mapping do
      source =
        Enum.find_value(roots, fn root ->
          source = Path.join(root, source_file_path)
          if File.exists?(source), do: source
        end) || raise "could not find #{source_file_path} in any of the sources"

      target = Path.join(target_dir, target_file_path)

      contents = File.read!(source)
      # case format do
      #   :eex  -> EEx.eval_file(source, binding)
      #   _ -> File.read!(source)
      # end

      Mix.Generator.create_file(target, contents)
    end
  end

  defp to_app_source(path, source_dir) when is_binary(path), do: Path.join(path, source_dir)
  defp to_app_source(app, source_dir) when is_atom(app), do: Application.app_dir(app, source_dir)
end

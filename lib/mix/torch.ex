defmodule Mix.Torch do
  @moduledoc false

  alias Torch.Config

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

  def ensure_phoenix_is_loaded(mix_task) do
    case Application.load(:phoenix) do
      :ok ->
        :ok

      {:error, {:already_loaded, :phoenix}} ->
        :ok

      {:error, reason} ->
        Mix.raise(
          "mix #{mix_task} could not complete due to Phoenix not being loaded: #{reason}"
        )
    end
  end
end

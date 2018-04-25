defmodule Mix.Tasks.Torch.Install do
  @moduledoc """
  Installs torch layout to your `_web/templates` directory.

  ## Configuration

      config :torch,
        otp_app: :my_app,
        template_format: :eex

  ## Example

  Running without options will read configuration from your `config.exs` file,
  as shown above.

     mix torch.install

  Also accepts `--format` and `--app` options:

      mix torch.install --format slim --app my_app
  """

  alias Torch.Config

  def run(args) do
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
          mix torch.install --app my_app
      """)
    end

    unless format in ["eex", "slim"] do
      Mix.raise("""
      Template format is invalid: #{inspect(format)}. Either configure it as
      shown below or pass it via the `--format` option.

          config :torch,
            template_format: :slim

          # Alternatively
          mix torch.install --format slim

      Supported formats: eex, slim
      """)
    end

    Mix.Torch.copy_from([:torch], "priv/templates/#{format}", "", [], [
      {:eex, "layout.html.#{format}", "lib/#{otp_app}_web/templates/layout/torch.html.#{format}"}
    ])
  end
end

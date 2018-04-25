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

  def run(args) do
    %{format: format, otp_app: otp_app} = Mix.Torch.parse_config!("torch.install", args)

    Mix.Torch.copy_from([:torch], "priv/templates/#{format}", "", [], [
      {:eex, "layout.html.#{format}", "lib/#{otp_app}_web/templates/layout/torch.html.#{format}"}
    ])
  end
end

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

  import Mix.Torch
  import Torch.Templates

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise("mix torch.install can only be run inside an application directory")
    end

    %{format: format, otp_app: otp_app} = parse_config!("torch.install", args)

    ensure_phoenix_is_loaded("torch.install")

    inject_templates(
      "torch.install",
      format: format,
      out_directory: "lib/#{otp_app}_web/templates/layout",
      suffixe: "torch_"
    )
  end
end

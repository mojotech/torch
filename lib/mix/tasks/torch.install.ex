defmodule Mix.Tasks.Torch.Install do
  @moduledoc """
  Installs torch layout to your `_web/templates` directory.

  ## Configuration

      config :torch,
        otp_app: :my_app

  ## Example

  Running without options will read configuration from your `config.exs` file,
  as shown above.

     mix torch.install

  Also accepts the `--app` option:

      mix torch.install --app my_app
  """

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise("mix torch.install can only be run inside an application directory")
    end

    %{otp_app: otp_app} = Mix.Torch.parse_config!("torch.install", args)

    Mix.Torch.ensure_phoenix_is_loaded!("torch.install")

    phoenix_version = :phoenix |> Application.spec(:vsn) |> to_string()

    if Version.match?(phoenix_version, "< 1.7.0") do
      Mix.raise(
        "Torch v5 Mix tasks will only run on Phoenix 1.7+.  Phoenix version detected: #{phoenix_version}"
      )
    end

    Mix.Torch.copy_from("priv/templates/torch.install", [
      {"layout.html.heex", "lib/#{otp_app}_web/components/layouts/torch.html.heex"}
    ])
  end
end

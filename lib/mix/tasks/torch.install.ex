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

      mix torch.install --format slime --app my_app
  """

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise("mix torch.install can only be run inside an application directory")
    end

    %{format: format, otp_app: otp_app} = Mix.Torch.parse_config!("torch.install", args)

    Mix.Torch.ensure_phoenix_is_loaded!("torch.install")

    phoenix_version = Application.spec(:phoenix, :vsn)

    Mix.Torch.copy_from("priv/templates/#{format}", [
      {template_file(phoenix_version, format),
       "lib/#{otp_app}_web/templates/layout/torch.html.#{format}"}
    ])
  end

  defp template_file(phoenix_version, format) when is_list(phoenix_version),
    do: phoenix_version |> to_string() |> template_file(format)

  defp template_file(phoenix_version, format) when is_binary(phoenix_version) do
    if Version.match?(phoenix_version, ">= 1.5.0") do
      "layout.phx1_5.html.#{format}"
    else
      "layout.html.#{format}"
    end
  end
end

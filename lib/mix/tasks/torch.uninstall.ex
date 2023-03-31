defmodule Mix.Tasks.Torch.Uninstall do
  @moduledoc """
  Uninstalls torch layout.

  ## Example

      mix torch.uninstall

  Also accepts the `--app` option:

      mix torch.uninstall --app my_app
  """

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise("mix torch.uninstall can only be run inside an application directory")
    end

    %{otp_app: otp_app} = Mix.Torch.parse_config!("torch.uninstall", args)

    Mix.Torch.ensure_phoenix_is_loaded!("torch.uninstall")

    phoenix_version = :phoenix |> Application.spec(:vsn) |> to_string()

    if Version.match?(phoenix_version, "< 1.7.0") do
      Mix.raise(
        "Torch v5 Mix tasks will only run on Phoenix 1.7+.  Phoenix version detected: #{phoenix_version}"
      )
    end

    paths = [
      "lib/#{otp_app}_web/components/layouts/torch.html.heex"
    ]

    Enum.each(paths, &File.rm/1)
  end
end

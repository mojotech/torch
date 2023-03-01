defmodule Mix.Tasks.Torch.Uninstall do
  @moduledoc """
  Uninstalls torch layout.

  ## Example

      mix torch.uninstall
  """

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise("mix torch.uninstall can only be run inside an application directory")
    end

    %{format: format, otp_app: otp_app} = Mix.Torch.parse_config!("torch.uninstall", args)

    Mix.Torch.ensure_phoenix_is_loaded!("torch.uninstall")

    phoenix_version = :phoenix |> Application.spec(:vsn) |> to_string()

    if Version.match?(phoenix_version, ">= 1.7.0") do
      Mix.raise(
        "Torch v4 Mix tasks will not run on Phoenix 1.7+.  Please upgrade to Torch v5 or newer."
      )
    end

    paths = [
      "lib/#{otp_app}_web/components/layouts/torch.html.#{format}"
    ]

    Enum.each(paths, &File.rm/1)
  end
end

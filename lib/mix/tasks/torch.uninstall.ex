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

    paths = [
      "lib/#{otp_app}_web/templates/layout/torch.html.#{format}"
    ]

    Enum.each(paths, &File.rm/1)
  end
end

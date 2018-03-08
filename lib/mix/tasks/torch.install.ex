defmodule Mix.Tasks.Torch.Install do
  @moduledoc """
  Installs torch layout.

  ## Example

      mix torch.install
  """

  import Torch.Config, only: [otp_app: 0, template_format: 0]

  def run(_) do
    Mix.Torch.copy_from([:torch], "priv/templates/#{template_format()}", "", [], [
      {:eex, "layout.html.#{template_format()}",
       "lib/#{otp_app()}_web/templates/layout/torch.html.#{template_format()}"}
    ])
  end
end
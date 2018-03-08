defmodule Mix.Tasks.Torch.Uninstall do
  @moduledoc """
  Uninstalls torch layout & templates.

  ## Example

      mix torch.uninstall
  """

  import Torch.Config, only: [otp_app: 0, template_format: 0]

  def run(_) do
    format = template_format()

    File.rm("priv/templates/phx.gen.html/controller_test.exs")
    File.rm("priv/templates/phx.gen.html/controller.ex")
    File.rm("priv/templates/phx.gen.html/edit.html.#{format}")
    File.rm("priv/templates/phx.gen.html/form.html.#{format}")
    File.rm("priv/templates/phx.gen.html/index.html.#{format}")
    File.rm("priv/templates/phx.gen.html/new.html.#{format}")
    File.rm("priv/templates/phx.gen.html/show.html.#{format}")
    File.rm("priv/templates/phx.gen.html/view.ex")
    File.rm("priv/templates/phx.gen.context/access_no_schema.ex")
    File.rm("priv/templates/phx.gen.context/context.ex")
    File.rm("priv/templates/phx.gen.context/schema_access.ex")
    File.rm("priv/templates/phx.gen.context/test_cases.exs")
    File.rm("priv/templates/phx.gen.context/context_test.exs")
    File.rm("lib/#{otp_app()}_web/templates/layout/torch.html.#{format}")
  end
end
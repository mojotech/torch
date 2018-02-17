defmodule Mix.Tasks.Torch.Uninstall do
  @moduledoc """
  Uninstalls torch templates from your project.

  ## Parameters

  - **Format**: Either 'eex' or 'slim'

  ## Example

      mix torch.uninstall my_app eex
      mix torch.uninstall my_app slim
  """

  def run([_opt_app, format]) do
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
  end
end
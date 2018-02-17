defmodule Mix.Tasks.Torch.Install do
  @moduledoc """
  Installs necessary templates from torch into your project's `priv/templates/phx.gen.*/*` directory.

  ## Parameters

  - **Format**: Either 'eex' or 'slim'

  ## Example

      mix torch.install my_app eex
      mix torch.install my_app slim
  """

  def run([project_name, format]) do
    # Copy over phoenix generator html templates
    Mix.Torch.copy_from([:torch], "priv/templates/#{format}/phx.gen.html", "", [], [
      {:exs, "controller_test.exs", "priv/templates/phx.gen.html/controller_test.exs"},
      {:ex, "controller.ex", "priv/templates/phx.gen.html/controller.ex"},
      {:eex, "edit.html.eex", "priv/templates/phx.gen.html/edit.html.eex"},
      {:eex, "form.html.eex", "priv/templates/phx.gen.html/form.html.eex"},
      {:eex, "index.html.eex", "priv/templates/phx.gen.html/index.html.eex"},
      {:eex, "new.html.eex", "priv/templates/phx.gen.html/new.html.eex"},
      {:eex, "show.html.eex", "priv/templates/phx.gen.html/show.html.eex"},
      {:ex, "view.ex", "priv/templates/phx.gen.html/view.ex"}
    ])

    # Copy over phoenix generator context templates
    Mix.Torch.copy_from([:torch], "priv/templates/phx.gen.context", "", [], [
      {:ex, "access_no_schema.ex", "priv/templates/phx.gen.context/access_no_schema.ex"},
      {:ex, "context.ex", "priv/templates/phx.gen.context/context.ex"},
      {:ex, "schema_access.ex", "priv/templates/phx.gen.context/schema_access.ex"},
      {:exs, "test_cases.exs", "priv/templates/phx.gen.context/test_cases.exs"},
      {:exs, "context_test.exs", "priv/templates/phx.gen.context/context_test.exs"}
    ])

    Mix.Torch.copy_from([:torch], "priv/templates/#{format}", "", [], [
      {:eex, "layout.html.#{format}",
       "lib/#{project_name}_web/templates/layout/admin.html.#{format}"}
    ])
  end
end
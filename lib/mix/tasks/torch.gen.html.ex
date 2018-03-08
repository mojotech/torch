defmodule Mix.Tasks.Torch.Gen.Html do
  @moduledoc """
  Light wrapper module around phx.gen.context. Installs and uninstalls context
  templates around running the phoenix generator.

  ## Parameters

  Takes all the same params as the regualar phx generators.

  # TODO

  ## Example

      mix torch.gen.context Accounts User users --no-schema
  """

  import Torch.Config, only: [template_format: 0]

  def run([context | args]) do
    format = template_format()

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

    Mix.Task.run("phx.gen.html", [context | args])

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

    Mix.shell().info("""
    Ensure the following is added to your endpoint.ex:

        plug(
          Plug.Static,
          at: "/torch",
          from: {:torch, "priv/static"},
          gzip: true,
          cache_control_for_etags: "public, max-age=86400",
          headers: [{"access-control-allow-origin", "*"}]
        )
    """)

    Mix.shell().info("""
    Also don't forget to add a link to layouts/torch.html.

        <nav class="torch-nav">
          <!-- nav links here -->
        </nav>
    """)

    Mix.shell().info("\u{1F525} #{IO.ANSI.yellow()}Torch generated html for #{context}!\u{1F525}")
  end
end

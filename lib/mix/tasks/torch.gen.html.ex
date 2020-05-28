defmodule Mix.Tasks.Torch.Gen.Html do
  @moduledoc """
  Light wrapper module around `mix phx.gen.html` which generates slightly
  modified HTML.

  Takes all the same params as the `phx.gen.html` task.

  ## Example

      mix torch.gen.html Accounts User users --no-schema
  """

  @commands ~w[phx.gen.html phx.gen.context]

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise("mix torch.gen.html can only be run inside an application directory")
    end

    %{format: format} = Mix.Torch.parse_config!("torch.gen.html", args)

    Mix.Torch.ensure_phoenix_is_loaded!("torch.gen.html")

    # First, backup the projects existing templates if they exist
    Enum.each(@commands, &Mix.Torch.backup_project_templates/1)

    # Inject the torch templates for the generator into the priv/
    # directory so they will be picked up by the Phoenix generator
    Enum.each(@commands, &Mix.Torch.inject_templates(&1, format))

    # Run the Phoenix generator
    if format == "slime" do
      Mix.Task.run("phx.gen.html.slime", args)
    else
      Mix.Task.run("phx.gen.html", args)
    end

    # Remove the injected templates from priv/ so they will not
    # affect future Phoenix generator commands
    Enum.each(@commands, &Mix.Torch.remove_templates/1)

    # Restore the projects existing templates if present
    Enum.each(@commands, &Mix.Torch.restore_project_templates/1)

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
  end
end

defmodule Mix.Tasks.Torch.Install do
  @moduledoc """
  Installs all the files Torch needs to run within the context of your
  Phoenix application.

  ## Example

      mix torch.install
  """

  use Mix.Task

  def run(_args) do
    Mix.Torch.copy_from [:torch], "priv/templates/eex", "", [], [
      {:eex, "layout.html.eex", "web/templates/layout/admin.html.eex"}
    ]

    Mix.Torch.copy_from [:torch], "priv/templates/sass", "", [], [
      {:text, "_variables.scss", "web/static/css/_admin_variables.scss"}
    ]

    Mix.shell.info """
    #{hr}
                                   #{IO.ANSI.yellow}TORCH INSTALLED!#{IO.ANSI.reset}
    #{hr}

    There are two final steps you must complete manually:

    1. Import the CSS styles. If you want to use the SASS styles, you should
       update your app.scss file to look like this:

        @import "admin_variables";
        @import "../../../node_modules/torch/web/static/css/torch";

       Torch also provides a precompiled CSS file in `priv/static/css/torch.css`
       if you are not using SASS.

    2. Add an admin scope to your router in `router.ex`:

        scope "/admin", #{Mix.Torch.base}, as: :admin do
          pipe_through :browser
        end

    With those steps complete, you can generate admin controllers with `torch.gen.html`.
    """
  end

  defp hr do
    for _ <- 1..80, into: "", do: "\u{1F525}"
  end
end

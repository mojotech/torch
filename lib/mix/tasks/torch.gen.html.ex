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

  import Torch.Config, only: [otp_app: 0, template_format: 0]

  def run([context | args]) do
    Mix.Task.run("torch.install", [otp_app(), template_format()])
    Mix.Task.run("phx.gen.html", [context | args])
    Mix.Task.run("torch.uninstall", [otp_app(), template_format()])

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
    #{hr()}
                            #{IO.ANSI.yellow()}Torch generated html for #{context}! #{
      IO.ANSI.reset()
    }
    #{hr()}
    """)
  end

  defp hr do
    for _ <- 1..80, into: "", do: "\u{1F525}"
  end
end
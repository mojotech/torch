defmodule Torch.Mixfile do
  use Mix.Project

  def project do
    [app: :torch,
     version: "1.0.0-rc.5",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     name: "Torch",
     description: "Rapid admin generator for Phoenix",
     package: package,
     docs: docs,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :phoenix, :ecto, :scrivener_ecto, :filtrex]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:myapp, in_umbrella: true}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:filtrex, "~> 0.3.0"},
     {:phoenix, "~> 1.2"},
     {:phoenix_html, "~> 2.6"},
     {:ecto, ">= 1.0.0"},
     {:scrivener_ecto, ">= 1.0.0"},
     {:credo, "~> 0.5", only: [:dev, :test]},
     {:ex_doc, "~> 0.13", only: :dev}]
  end

  defp package do
    [
      maintainers: ["Daniel Berkompas"],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/infinitered/torch"
      },
      files: ~w(lib priv web brunch-config.js mix.exs package.json README.md)
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(_),     do: ["lib", "web"]
end

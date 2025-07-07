defmodule Torch.MixProject do
  use Mix.Project

  @source_url "https://github.com/mojotech/torch"
  @version "5.6.0"

  def project do
    [
      app: :torch,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      name: "Torch",
      description: "Rapid admin generator for Phoenix",
      source_url: @source_url,
      homepage_url: @source_url,
      test_paths: ["test/mix", "test/torch"],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support/cases"]
  defp elixirc_paths(_env), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.7"},
      {:phoenix_live_view, "~> 1.0 or ~> 0.20"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_html_helpers, "~> 1.0"},
      {:gettext, "~> 0.16"},
      {:scrivener_ecto, "~> 3.0"},
      {:filtrex, "~> 0.4.1"},
      {:jason, "~> 1.2", only: [:dev, :test]},
      {:excoveralls, ">= 0.0.0", only: [:dev, :test]},
      {:credo, "~> 1.1", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:ex_unit_notifier, "~> 1.0", only: [:test]},
      {:mix_test_watch, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["MojoTech"],
      licenses: ["MIT"],
      files: ~w(lib priv mix.exs README.md LICENSE CHANGELOG.md CODE_OF_CONDUCT.md UPGRADING.md),
      links: %{
        "Github" => @source_url
      }
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [title: "Changelog"],
        "CODE_OF_CONDUCT.md": [title: "Code of Conduct"],
        LICENSE: [title: "License"],
        "README.md": [title: "Overview"],
        "UPGRADING.md": [title: "Upgrading"]
      ],
      main: "readme",
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end

defmodule Torch.MixProject do
  use Mix.Project

  def project do
    [
      app: :torch,
      version: "3.5.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      name: "Torch",
      description: "Rapid admin generator for Phoenix",
      source_url: "https://github.com/mojotech/torch",
      homepage_url: "https://github.com/mojotech/torch",
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
      {:phoenix, ">= 1.3.0 and < 1.6.0"},
      {:phoenix_html, "~> 2.10"},
      {:gettext, "~> 0.16"},
      {:scrivener_ecto, ">= 1.2.1"},
      {:filtrex, "~> 0.4.1"},
      {:timex, "~> 3.1"},
      {:jason, ">= 0.0.0", only: [:dev, :test]},
      {:excoveralls, ">= 0.0.0", only: [:dev, :test]},
      {:credo, "~> 1.1", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: [:dev, :test]},
      {:ex_unit_notifier, "~> 0.1", only: [:test]},
      {:mix_test_watch, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["MojoTech"],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/mojotech/torch"
      },
      files: ~w(lib priv mix.exs README.md)
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end
end

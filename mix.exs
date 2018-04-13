defmodule Torch.MixProject do
  use Mix.Project

  def project do
    [
      app: :torch,
      version: "2.0.0-rc.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      compilers: [:phoenix] ++ Mix.compilers(),
      name: "Torch",
      description: "Rapid admin generator for Phoenix",
      source_url: "https://github.com/infinitered/torch",
      homepage_url: "https://github.com/infinitered/torch",
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.3"},
      {:phoenix_html, "~> 2.10"},
      {:scrivener_ecto, ">= 1.2.1"},
      {:filtrex, "~> 0.4.1"},
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:ex_doc, "~> 0.13", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Infinite Red"],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/infinitered/torch"
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

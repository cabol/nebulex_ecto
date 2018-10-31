defmodule Nebulex.Ecto.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :nebulex_ecto,
      version: @version,
      elixir: "~> 1.5",
      deps: deps(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      description: "Integration between Nebulex & Ecto"
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:nebulex, "~> 1.0"},

      # Test
      {:ecto, "~> 2.0", only: :test},
      {:postgrex, "~> 0.11", only: :test},
      {:excoveralls, "~> 0.6", only: :test},

      # Docs
      {:ex_doc, ">= 0.0.0", only: :docs}
    ]
  end

  defp package do
    [
      name: :nebulex_ecto,
      maintainers: ["Carlos A Bolanos"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/cabol/nebulex_ecto"}
    ]
  end
end

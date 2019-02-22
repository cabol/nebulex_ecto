defmodule NebulexEcto.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :nebulex_ecto,
      version: @version,
      elixir: "~> 1.5",
      deps: deps(),

      # Docs
      name: "NebulexEcto",
      docs: docs(),

      # Test
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # Dialyzer
      dialyzer: dialyzer(),

      # Hex
      package: package(),
      description: "Ecto & Nebulex Integration – Ecto Cacheable Repo with Nebulex"
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

      # Code Analysis
      {:dialyxir, "~> 0.5", optional: true, only: [:dev, :test], runtime: false},
      {:credo, "~> 0.10", optional: true, only: [:dev, :test]},

      # Docs
      {:ex_doc, "~> 0.19", only: :docs},
      {:inch_ex, "~> 1.0", only: :docs}
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

  defp docs do
    [
      main: "NebulexEcto",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/nebulex_ecto",
      source_url: "https://github.com/cabol/nebulex_ecto"
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [],
      flags: [
        :unmatched_returns,
        :error_handling,
        :race_conditions,
        :no_opaque,
        :unknown,
        :no_return
      ]
    ]
  end
end

defmodule Nebulex.Ecto.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :nebulex_ecto,
     version: @version,
     elixir: "~> 1.3",
     deps: deps(),
     package: package(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
     description: "Integration between Nebulex & Ecto"]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:nebulex, "~> 1.0.0-rc.1"},

     {:ecto, "~> 2.0", only: :test},
     {:postgrex, "~> 0.11", only: :test},
     #{:ecto_mnesia, "~> 0.9", only: :test},
     {:excoveralls, "~> 0.6", only: :test},
     {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}]
  end

  defp package do
    [name: :nebulex_ecto,
     maintainers: ["Carlos A Bolanos"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/cabol/nebulex_ecto"}]
  end
end

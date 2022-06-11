defmodule Atomix.MixProject do
  use Mix.Project

  def project do
    [
      app: :atomix,
      version: "0.1.0",
      name: "Atomix",
      source_url: "https://github.com/taguniversalmachine/atomix",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
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
      {:exatomvm, path: "/Users/eflores/src/ExAtomVM"},
      {:jason, "~> 1.3"},
      {:finch, "~> 0.12.0"},
      {:csv, "~> 2.4.1"},
      {:ex_doc, "~> 0.27"},
      {:earmark, "~> 1.4.25"},
      {:nimble_parsec, "~> 1.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end

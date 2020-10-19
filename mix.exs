defmodule LogViewer.MixProject do
  use Mix.Project

  def project do
    [
      app: :log_viewer,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {LogViewer, {}},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 1.0 or ~> 2.0"},
      {:plug, "~> 1.0"},
      {:jason, ">= 0.0.0"},
      {:exsync, "~> 0.2", only: :dev},
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.23.0", only: :dev}
    ]
  end

  defp description do
    """
    An Web based Log Viewer for Elixir and Phoenix
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*", "priv"],
      maintainers: ["Shuhei Hayashibara"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/shufo/log_viewer",
        "Docs" => "https://hexdocs.pm/log_viewer"
      }
    ]
  end
end

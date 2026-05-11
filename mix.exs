defmodule OpentelemetryCommanded.MixProject do
  use Mix.Project

  def project do
    [
      app: :opentelemetry_commanded,
      version: "0.2.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      elixirc_options: [warnings_as_errors: true],
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      dialyzer: [plt_add_deps: :apps_direct, plt_add_apps: [:ex_unit], ignore_warnings: ".dialyzer_ignore.exs"],
      description: "Trace Commanded CQRS operations with OpenTelemetry",
      source_url: "https://github.com/ukchukx/opentelemetry_commanded",
      homepage_url: "https://github.com/ukchukx/opentelemetry_commanded",
      docs: docs()
    ]
  end

  def cli do
    [
      preferred_envs: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ]
    ]
  end

  defp elixirc_paths(env) when env in [:test],
    do: [
      "lib",
      "test/support",
      "test/dummy_app"
    ]

  defp elixirc_paths(_env), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [:logger]]
  end

  defp package do
    [
      description: "Trace Commanded CQRS operations with OpenTelemetry",
      licenses: ["Apache-2"],
      maintainers: ["Uk Chukundah"],
      links: %{
        "GitHub" => "https://github.com/ukchukx/opentelemetry_commanded",
        "Docs" => "https://hexdocs.pm/opentelemetry_commanded"
      },
      files: ~w(lib mix.exs .formatter.exs .dialyzer_ignore.exs README.md)
    ]
  end

  defp deps do
    [
      {:commanded, "~> 1.4"},
      {:opentelemetry_telemetry, "~> 1.1"},
      {:opentelemetry_api, "~> 1.5"},
      {:telemetry, "~> 1.4"},
      {:opentelemetry, "~> 1.7"},

      # Testing
      {:jason, "~> 1.4", only: :test},
      {:ecto, "~> 3.13", only: :test},
      {:excoveralls, "~> 0.18", only: :test, optional: true},
      {:credo, "~> 1.6", only: :test, runtime: false, optional: true},
      {:dialyxir, "~> 1.4", only: :test, runtime: false, optional: true},

      # Tools
      {:ex_doc, ">= 0.0.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"],
      extras: [
        "README.md",
        "CHANGELOG.md"
      ]
    ]
  end
end

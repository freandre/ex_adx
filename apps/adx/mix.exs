defmodule Adx.MixProject do
  use Mix.Project

  def project do
    [
      app: :adx,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Adx.Application, [:cowboy, :plug, :ex_rated, :httpoison]}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:ex_rated, "~> 1.2"},
      {:httpoison, "~> 1.0"},
      {:ex_openrtb, git: "https://github.com/freandre/ex_openrtb.git"},
      {:exchangerate, in_umbrella: true},
      {:dsp, in_umbrella: true}
    ]
  end
end

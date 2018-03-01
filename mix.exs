defmodule Qsm.Mixfile do
  use Mix.Project

  def project do
    [
      app: :qsm,
      version: "0.1.0",
      elixir: "~> 1.6.1",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:e_poller, "~> 0.1.1"},
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end
end

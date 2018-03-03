defmodule Qsm.Mixfile do
  use Mix.Project

  def project do
    [
      app: :qsm,
      version: "0.1.0",
      elixir: "~> 1.6.1",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      name: "qsm",
      source_url: "https://github.com/vishalkuo/qsm",
      package: package()
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

  defp description() do 
    "A finite state machine built on top of SQS."
  end

  defp package do
    [
      name: "qsm",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Vishal Kuo", "Justin Trudell"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/vishalkuo/qsm"}
    ]
  end
end

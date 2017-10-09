defmodule IdleTimeout.Mixfile do
  use Mix.Project

  def project do
    [app: :idle_timeout,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps(),

     # Docs:
     name: "IdleTimeout",
     source_url: "https://github.com/niko/idle_timeout_ex",
     homepage_url: "https://github.com/niko/idle_timeout_ex",
     docs: [main: "IdleTimeout",
            extras: ["README.md"]]

    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, "~> 0.16", only: :dev, runtime: false}]
  end

  defp description() do
    "A simple mechanism to timeout idle Elixir processes - for example a GenServer - after a given period of inactivity."
  end

  defp package() do
    [
      name: "idle_timeout_ex",
      files: ["lib", "test", "mix.exs", "README.md"],
      maintainers: ["Niko Dittmann"],
      licenses: ["Do-what-you-want"],
      links: %{"GitHub" => "https://github.com/niko/idle_timeout_ex"}
    ]
  end

end

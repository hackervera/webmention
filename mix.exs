defmodule Webmention.Mixfile do
  use Mix.Project

  def project do
    [app: :webmention,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpotion, :ibrowse]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:httpotion, "~> 3.0.2"},{:floki, "~> 0.11.0"},{:jsx, "~> 2.8"}, {:pattern_tap, "~> 0.2.2"}]
  end
end

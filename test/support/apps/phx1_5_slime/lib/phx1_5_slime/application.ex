defmodule Phx15Slime.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Phx15Slime.Repo,
      # Start the Telemetry supervisor
      Phx15SlimeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Phx15Slime.PubSub},
      # Start the Endpoint (http/https)
      Phx15SlimeWeb.Endpoint
      # Start a worker by calling: Phx15Slime.Worker.start_link(arg)
      # {Phx15Slime.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Phx15Slime.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Phx15SlimeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

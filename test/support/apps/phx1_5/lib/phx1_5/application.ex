defmodule Phx15.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Phx15.Repo,
      # Start the Telemetry supervisor
      Phx15Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Phx15.PubSub},
      # Start the Endpoint (http/https)
      Phx15Web.Endpoint
      # Start a worker by calling: Phx15.Worker.start_link(arg)
      # {Phx15.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Phx15.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Phx15Web.Endpoint.config_change(changed, removed)
    :ok
  end
end

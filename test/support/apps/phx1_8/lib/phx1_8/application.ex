defmodule Phx18.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Phx18Web.Telemetry,
      Phx18.Repo,
      {DNSCluster, query: Application.get_env(:phx1_8, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Phx18.PubSub},
      # Start a worker by calling: Phx18.Worker.start_link(arg)
      # {Phx18.Worker, arg},
      # Start to serve requests, typically the last entry
      Phx18Web.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Phx18.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Phx18Web.Endpoint.config_change(changed, removed)
    :ok
  end
end

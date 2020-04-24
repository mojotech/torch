# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phx1_4,
  ecto_repos: [Phx14.Repo]

# Configures the endpoint
config :phx1_4, Phx14Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/Uh4oOUwnf+9kNTql57GpTMGAhRVek1k48HzDdh7TQhZlIRhAAv2XBVf6QR3ymSh",
  render_errors: [view: Phx14Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Phx14.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :torch,
  otp_app: :phx1_4,
  template_format: "eex"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

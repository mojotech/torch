# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phx1_5,
  ecto_repos: [Phx15.Repo]

# Configures the endpoint
config :phx1_5, Phx15Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BUbjevGvzUc4RGVVRtmP36D1GVJf9BRWeJFXfDR9XdiqBMxI15rWb7zJS5oOtpds",
  render_errors: [view: Phx15Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Phx15.PubSub,
  live_view: [signing_salt: "2yuy90gW"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :torch,
  otp_app: :phx1_5,
  template_format: "eex"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

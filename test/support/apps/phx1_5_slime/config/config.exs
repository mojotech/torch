# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phx1_5_slime,
  ecto_repos: [Phx15Slime.Repo]

# Configures the endpoint
config :phx1_5_slime, Phx15SlimeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "caAgKW69NkuxZYieMe0p8w05fBraST0p2bpXPqFsChAoE3YFkckfig2pjC8i6Jyc",
  render_errors: [view: Phx15SlimeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Phx15Slime.PubSub,
  live_view: [signing_salt: "eFRHpkJx"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :torch,
       otp_app: :phx1_5_slime,
       template_format: "slime"

config :phoenix, :template_engines,
       slim: PhoenixSlime.Engine,
       slime: PhoenixSlime.Engine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

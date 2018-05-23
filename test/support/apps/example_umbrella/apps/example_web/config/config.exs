# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :example_web,
  ecto_repos: [Example.Repo],
  generators: [context_app: :example]

# Configures the endpoint
config :example_web, ExampleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "L9G7txdd5DbMQFjO5TNhYcK+NkQlOpAPWZwd3gJ6pwRGco5gsAL/Vw7kGK/u+8fK",
  render_errors: [view: ExampleWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ExampleWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :torch,
  otp_app: :example,
  template_format: :eex

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

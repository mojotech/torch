use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :example, Example.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Set up test project
{whoami, _} = System.cmd("whoami", [])
whoami = String.replace(whoami, "\n", "")

config :example, Example.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "example_test",
  username: System.get_env("DATABASE_POSTGRESQL_USERNAME") || whoami,
  password: System.get_env("DATABASE_POSTGRESQL_PASSWORD") || nil,
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 60_000

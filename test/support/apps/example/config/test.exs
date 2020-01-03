use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :example, ExampleWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
{whoami, _} = System.cmd("whoami", [])
whoami = String.replace(whoami, "\n", "")

# Configure your database
config :example, Example.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_POSTGRESQL_USERNAME") || whoami,
  password: System.get_env("DATABASE_POSTGRESQL_PASSWORD") || "",
  database: "example_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

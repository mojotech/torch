use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phx1_4, Phx14Web.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
{whoami, _} = System.cmd("whoami", [])
whoami = String.replace(whoami, "\n", "")

config :phx1_4, Phx14.Repo,
  username: System.get_env("DATABASE_POSTGRESQL_USERNAME") || whoami,
  password: System.get_env("DATABASE_POSTGRESQL_PASSWORD") || "",
  database: "phx1_4_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

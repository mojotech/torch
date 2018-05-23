use Mix.Config

# Configure your database
config :example, Example.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "example_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

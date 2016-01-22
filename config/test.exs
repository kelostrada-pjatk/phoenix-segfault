use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :segfault, Segfault.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :segfault, Segfault.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "segfault_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# use easy encryption so tests don't slow down dramatically
config :comeonin, bcrypt_log_rounds: 4
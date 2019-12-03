use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :data_processor_backend, DataProcessorBackendWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :data_processor_backend, DataProcessorBackend.Repo,
  username: "postgres",
  password: "postgres",
  database: "data_processor_backend_test",
  hostname: System.get_env("DATABASE_HOST"),
  pool: Ecto.Adapters.SQL.Sandbox

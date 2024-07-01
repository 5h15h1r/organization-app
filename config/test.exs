import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :organization_api, OrganizationApi.Repo,
  username: System.get_env("POSTGRES_USERNAME"),
  password: System.get_env("POSTGRES_PASSWORD"),
  hostname: "localhost",
  database: "organization_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# Prevents Oban from running job during test runs
config :organization_api, Oban, testing: :inline

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :organization_api, OrganizationApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "DebhssVeCJefbZkFFbfAqInjLcGtDxEXDCe40VmPJhmPj7LzPaT5eUp2TF5S/CyI",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# config :phoenix_live_view,
  # Enable helpful, but potentially expensive runtime checks
  # enable_expensive_runtime_checks: true

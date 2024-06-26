# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

if config_env() in [:dev, :test] do
  import_config ".env.exs"
end
# Configures Oban
config :organization_api, Oban,
  engine: Oban.Engines.Basic,
  queues: [audit_logs: 10],
  repo: OrganizationApi.Repo

config :organization_api,
  ecto_repos: [OrganizationApi.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :organization_api, OrganizationApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: OrganizationApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: OrganizationApi.PubSub,
  live_view: [signing_salt: "Bi9VQORf"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

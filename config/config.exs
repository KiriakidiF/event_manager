# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :event_manager,
  ecto_repos: [EventManager.Repo]

# Configures the endpoint
config :event_manager, EventManagerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6s1h14WiwfYTZB7uB394muzwDQziMBhuZd0uRcUPijr7Gp24QDkeJhizJrpTREfL",
  render_errors: [view: EventManagerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: EventManager.PubSub,
  live_view: [signing_salt: "NicfLZGI"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the namespace used by Phoenix generators
config :bnote,
  app_namespace: BNote

# Configures the endpoint
config :bnote, BNote.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "f9vtDWh/NSRfP3WU4yi6lE2/qc2QRmsyXPNJtm+dQ9bah1tUcRNwHxOYCNIzwfXn",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: BNote.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

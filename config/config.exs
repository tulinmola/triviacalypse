# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :triviacalypse, TriviacalypseWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "r20uyXozL8f8rGOBia5C66X5a59Nxa13Cn0H2MsA88nv1S+RBxd/COI1b7tYDzQL",
  render_errors: [view: TriviacalypseWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Triviacalypse.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

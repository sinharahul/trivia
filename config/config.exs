# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :trivia, TriviaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "e/M5kgk6eLxUXb8kFsySNK7XNkme/NSmn7cQ7kq+1YZCBscGKYt4cA6nTz7azA2F",
  render_errors: [view: TriviaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Trivia.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :trivia, message_limit: 100
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

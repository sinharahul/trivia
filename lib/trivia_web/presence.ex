defmodule TriviaWeb.Presence do
  use Phoenix.Presence, otp_app: :trivia,
                        pubsub_server: Trivia.PubSub
end

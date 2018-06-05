defmodule Trivia.Message do
  defstruct [:sender, :text, :timestamp]

  def new(sender, text) do
    %__MODULE__{sender: sender, text: text, timestamp: DateTime.utc_now()}
  end
end

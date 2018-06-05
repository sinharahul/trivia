defmodule Trivia.Chat do
  alias Trivia.Message

  defstruct messages: [], length: 0

  def new do
    %__MODULE__{}
  end

  def add_message(%__MODULE__{messages: msgs, length: len} = chat, sender, text) do
    messages = cond do
      length(msgs) == message_limit() ->
        Enum.drop(msgs, 1)
      true ->
        msgs
    end

    %{chat | messages: messages ++ [Message.new(sender, text)], length: len + 1}
  end

  def message(%__MODULE__{messages: messages}, index) do
    Enum.at(messages, index)
  end

  defp message_limit do
    Application.get_env(:trivia, :message_limit)
  end
end

defmodule Trivia.ChatTest do
  use ExUnit.Case

  alias Trivia.Chat

  describe "new/0" do
    test "it initializes a chat with no messages and length 0" do
      chat = Chat.new()

      assert Enum.empty?(chat.messages)
      assert chat.length == 0
    end
  end

  describe "add_message/3" do
    test "it adds a message to the list" do
      chat = Chat.new() |> Chat.add_message("Matt", "test")

      assert Chat.message(chat, 0).sender == "Matt"
    end

    test "it drops the oldest message if we reach the message_limit" do
      chat = Chat.new() |> Chat.add_message("Matt", "first")

      limit = Application.get_env(:trivia, :message_limit)
      chat = Enum.reduce(1..limit, chat, &(Chat.add_message(&2, "Matt", &1)))

      assert length(chat.messages) == 100
      refute Chat.message(chat, 0).text == "first"
    end

    test "it updates the length attribute" do
      chat = Chat.new() |> Chat.add_message("Matt", "first")

      assert chat.length == 1
    end
  end

  describe "message/2" do
    test "it returns the message at the index" do
      chat = Chat.new() |> Chat.add_message("Matt", "test")

      assert Chat.message(chat, 0).sender == "Matt"
    end

    test "it returns nil if no message at index" do
      refute(Chat.new() |> Chat.message(0))
    end
  end
end

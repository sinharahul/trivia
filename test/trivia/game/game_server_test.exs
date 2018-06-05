defmodule Trivia.GameServerTest do
  use ExUnit.Case
  use Trivia.Unique

  alias Trivia.GameServer
  alias Trivia.Question
  alias Trivia.Chat
  alias Trivia.Message

  setup %{game: game} do
    {:ok, pid} = GameServer.start_link(game)
    {:ok, %{pid: pid}}
  end

  describe "add_question/1" do
    test "it adds a question", %{game: game} do
      GameServer.add_question(game)

      assert GameServer.question(game, 0)
      assert GameServer.question(game, 1)
    end
  end

  describe "vote/4" do
    test "it adds votes for an answer on a question", %{game: game} do
      assert GameServer.vote(game, 1, :a, 5).votes.a == 5
    end
  end

  describe "reset/1" do
    test "it replaces the current state with a new game", %{game: game} do
      GameServer.vote(game, 1, :a, 5)
      GameServer.vote(game, 1, :b, 10)
      GameServer.add_question(game)
      GameServer.vote(game, 2, :c, 15)
      GameServer.vote(game, 2, :b, 1)
      GameServer.reset(game)

      assert GameServer.question(game, 1).votes == %{a: 0, b: 0, c: 0}
      refute GameServer.question(game, 2)
    end
  end

  describe "whereis/1" do
    test "it takes in a room game and returns a pid", %{pid: pid, game: game} do
      assert GameServer.whereis(game) == pid
    end
  end

  describe "question/2" do
    test "it returns a question if one exists", %{game: game} do
      question = GameServer.question(game, 1)
      assert question.__struct__ == Question
    end

    test "it returns nil otherwise", %{game: game} do
      refute GameServer.question(game, 2)
    end
  end

  describe "add_message/3" do
    test "it returns the message", %{game: game} do
      message = GameServer.add_message(game, "Matt", "test")

      assert message.__struct__ == Message
      assert message.sender == "Matt"
      assert message.text == "test"
    end
  end

  describe "chat/1" do
    test "it returns the chat", %{game: game} do
      chat = GameServer.chat(game)
      assert chat.__struct__ == Chat
    end
  end
end

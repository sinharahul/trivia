defmodule TriviaWeb.GameChannelTest do
  use TriviaWeb.ChannelCase
  use Trivia.Unique

  alias TriviaWeb.UserSocket
  alias Trivia.Question
  alias Trivia.Chat

  setup %{game: game} do
    {:ok, socket} = connect(UserSocket, %{})
    Trivia.create_game(game)

    {:ok, %{socket: socket}}
  end

  describe "join/3" do
    test "it sets the game on the socket", %{socket: socket, game: game} do
      {:ok, _, socket} = join(socket, "game:" <> game)
      assert socket.assigns.game == game
    end

    test "it sets the question on the socket to 1", %{socket: socket, game: game} do
      {:ok, _, socket} = join(socket, "game:" <> game)
      assert socket.assigns.question == 1
    end

    test "it sends the first question and chat as a reply", ctx do
      {:ok, reply, _} = join(ctx.socket, "game:" <> ctx.game)

      assert reply.question == %Question{}
      assert reply.chat == %Chat{}
    end
  end

  describe "handle_in:next" do
    test "replies with a new question if no next exists", %{socket: socket, game: game} do
      {:ok, _reply, socket} = join(socket, "game:" <> game)

      ref = push(socket, "next")
      assert_reply ref, :ok, %{question: %Question{}}
    end

    test "replies with the next question if it exists", %{socket: socket, game: game} do
      {:ok, _reply, socket} = join(socket, "game:" <> game)

      Trivia.add_question(game)
      Trivia.vote(game, 2, :a, 5)

      ref = push(socket, "next")
      assert_reply ref, :ok, %{question: %Question{votes: %{a: 5}}}
    end
  end

  describe "handle_in:back" do
    test "replies with the first question if at question 1", %{socket: socket, game: game} do
      {:ok, _reply, socket} = join(socket, "game:" <> game)

      Trivia.vote(game, 1, :a, 5)

      ref = push(socket, "back")
      assert_reply ref, :ok, %{question: %Question{votes: %{a: 5}}}
    end

    test "replies with the previous question otherwise", %{socket: socket, game: game} do
      {:ok, _reply, socket} = join(socket, "game:" <> game)

      Trivia.vote(game, 1, :a, 5)

      push(socket, "next")

      ref = push(socket, "back")
      assert_reply ref, :ok, %{question: %Question{votes: %{a: 5}}}
    end
  end

  describe "handle_in:vote" do
    test "broadcasts the updated question", %{socket: socket, game: game} do
      {:ok, _reply, socket} = subscribe_and_join(socket, "game:" <> game)

      push(socket, "vote", %{"answer" => "a", "strength" => "10"})
      assert_broadcast "new_vote", %{question: %Question{votes: %{a: 10}}}
    end

    test "sockets on other questions do not receive the update", ctx do
      {:ok, _, socket} = subscribe_and_join(ctx.socket, "game:" <> ctx.game)
      {:ok, _, socket2} = subscribe_and_join(ctx.socket, "game:" <> ctx.game)

      push(socket2, "next")
      push(socket, "vote", %{"answer" => "a", "strength" => "10"})

      assert_push "new_vote", %{question: %Question{votes: %{a: 10}}}
      refute_push "new_vote", %{question: %Question{votes: %{a: 10}}}
    end
  end

  describe "handle_in:propose_reset" do
    test "broadcast the message back", %{socket: socket, game: game} do
      {:ok, _reply, socket} = subscribe_and_join(socket, "game:" <> game)

      push(socket, "propose_reset")
      assert_broadcast "reset_proposed", %{}
    end
  end

  describe "handle_in:reject_reset" do
    test "broadcast the message back", %{socket: socket, game: game} do
      {:ok, _reply, socket} = subscribe_and_join(socket, "game:" <> game)

      push(socket, "reject_reset")
      assert_broadcast "reset_rejected", %{}
    end
  end

  describe "handle_in:reset" do
    test "it reset game and broadcasts an empty question", ctx do
      {:ok, _reply, socket} = subscribe_and_join(ctx.socket, "game:" <> ctx.game)

      Trivia.vote(ctx.game, 1, :a, 5)
      Trivia.vote(ctx.game, 1, :b, 10)
      Trivia.vote(ctx.game, 1, :c, 15)

      push(socket, "reset")

      assert_broadcast "reset", %{question: %Question{}}

      assert Trivia.question(ctx.game, 1)
      refute Trivia.question(ctx.game, 2)
      refute Trivia.question(ctx.game, 3)
    end
  end

  describe "handle_in:new_message" do
    test "it adds a new message to the chat and broadcasts it back out", ctx do
      {:ok, _reply, socket} = subscribe_and_join(ctx.socket, "game:" <> ctx.game)

      push(socket, "new_message", %{"sender" => "Matt", "text" => "test"})
      assert_broadcast "new_message", %{message: %{sender: "Matt", text: "test"}}

      chat = Trivia.chat(ctx.game)
      message = Chat.message(chat, 0)

      assert message.sender == "Matt"
      assert message.text == "test"
    end
  end
end

defmodule Trivia.GameTest do
  alias Trivia.Game
  alias Trivia.Question

  use ExUnit.Case

  setup do
    {:ok, game: Game.new()}
  end

  describe "new/0" do
    test "it returns a Game struct" do
      assert Game.new.__struct__ == Game
    end

    test "it populates itself with one question" do
      assert length(Game.new.questions) == 1
    end
  end

  describe "add_question/1" do
    test "it adds a question to the questions list", %{game: game} do
      game = Game.add_question(game)

      assert length(game.questions) == 2
    end

    test "it updates the length attribute", %{game: game} do
      game = Game.add_question(game)

      assert game.length == 2
    end
  end

  describe "vote/4" do
    test "it adds the correct number of votes to the right question", %{game: game} do
      game = game
        |> Game.add_question()
        |> Game.add_question()
        |> Game.vote(0, :a, 5)

      updated_question = Enum.at(game.questions, 0)

      assert Question.votes(updated_question, :a) == 5
    end
  end

  describe "question/2" do
    test "it looks up the question at the given index" do
      game = Game.new()

      assert Game.question(game, 0)
      refute Game.question(game, 1)
    end
  end
end

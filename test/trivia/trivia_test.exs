defmodule Trivia.TriviaTest do
  use ExUnit.Case
  use Trivia.Unique

  describe "create_game/1" do
    test "it returns the name of the game if successful", %{game: game} do
      assert Trivia.create_game(game) == game
    end

    test "it returns false otherwise", %{game: game} do
      assert Trivia.create_game(game) == game
      refute Trivia.create_game(game)
    end
  end

  describe "exists?/1" do
    test "it returns true if the game exists", %{game: game} do
      Trivia.create_game(game)
      assert Trivia.exists?(game)
    end

    test "it returns false if the game doesn't exist", %{game: game} do
      refute Trivia.exists?(game)
    end
  end
end

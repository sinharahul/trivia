defmodule Trivia.GameControllerTest do
  use TriviaWeb.ConnCase
  use Trivia.Unique

  describe "POST /games" do
    test "it renders the homepage if the game already exists", ctx do
      Trivia.create_game(ctx.game)

      conn = post ctx.conn, game_path(ctx.conn, :create), name: ctx.game
      assert html_response(conn, 200) =~ "Welcome back, HQtie!"
    end

    test "it shows a link to the game if it already exists", ctx do
      Trivia.create_game(ctx.game)

      conn = post ctx.conn, game_path(ctx.conn, :create), name: ctx.game

      assert html_response(conn, 200) =~ "This room already exists."
      assert html_response(conn, 200) =~ "#{game_path(conn, :show, ctx.game)}"
    end

    test "it creates the game and redirect to the show page otherwise", ctx do
      conn = post ctx.conn, game_path(ctx.conn, :create), name: ctx.game
      assert redirected_to(conn) =~ game_path(conn, :show, ctx.game)
    end
  end

  describe "GET /games/:name" do
    test "it creates the game if it doesn't exist", %{conn: conn, game: game} do
      refute Trivia.exists?(game)

      get conn, game_path(conn, :show, game)

      assert Trivia.exists?(game)
    end

    test "it render the show.html", %{conn: conn, game: game} do
      conn = get conn, game_path(conn, :show, game)
      assert html_response(conn, 200) =~ game
    end
  end
end

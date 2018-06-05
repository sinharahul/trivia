defmodule TriviaWeb.GameController do
  use TriviaWeb, :controller

  alias TriviaWeb.PageView

  def create(conn, %{"name" => name}) do
    case Trivia.create_game(name) do
      false ->
        conn |> put_flash(:error, "game already exists") |> render(PageView, :index, %{})
      ^name ->
        redirect(conn, to: game_path(conn, :show, name))
    end
  end

  def show(conn, %{"name" => name}) do
    if not Trivia.exists?(name) do
      Trivia.create_game(name)
    end

    render(conn, "show.html", %{name: name})
  end
end

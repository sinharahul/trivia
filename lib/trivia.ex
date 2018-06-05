defmodule Trivia do
  alias Trivia.GameServer
  alias Trivia.GameSupervisor
  @moduledoc """
  Trivia keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def create_game(name) do
    with {:ok, _pid} <- GameSupervisor.start_child(name) do
      name
    else
      _error -> false
    end
  end

  def vote(game, question, answer, strength) do
    GameServer.vote(game, question, answer, strength)
  end

  def add_question(game) do
    GameServer.add_question(game)
  end

  def add_message(game, sender, text) do
    GameServer.add_message(game, sender, text)
  end

  def chat(game) do
    GameServer.chat(game)
  end

  def question(game, number) do
    GameServer.question(game, number)
  end

  def reset(game) do
    GameServer.reset(game)
  end

  def exists?(game) do
    not is_nil(GameServer.whereis(game))
  end
end

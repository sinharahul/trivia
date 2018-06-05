defmodule Trivia.GameServer do
  use GenServer

  alias Trivia.Game
  alias Trivia.Chat

  defstruct [:game, :chat]

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: via(name))
  end

  def add_question(name) do
    GenServer.call(via(name), :add_question)
  end

  def add_message(name, sender, text) do
    GenServer.call(via(name), {:add_message, sender, text})
  end

  def chat(name) do
    GenServer.call(via(name), :chat)
  end

  def question(name, number) do
    GenServer.call(via(name), {:question, number})
  end

  def vote(name, question, answer, strength) do
    GenServer.call(via(name), {:vote, question, answer, strength})
  end

  def whereis(name) do
    GenServer.whereis(via(name))
  end

  def reset(name) do
    GenServer.call(via(name), :reset)
  end

  def init(_) do
    {:ok, %__MODULE__{game: Game.new(), chat: Chat.new()}}
  end

  def handle_call(:add_question, _from, state) do
    game = Game.add_question(state.game)
    question = Game.question(game, game.length - 1)

    {:reply, question, %{state | game: game}}
  end

  def handle_call({:vote, number, answer, strength}, _from, state) do
    game = Game.vote(state.game, number - 1, answer, strength)
    question = Game.question(game, number - 1)

    {:reply, question, %{state | game: game}}
  end

  def handle_call(:reset, _from, state) do
    game = Game.new()
    question = Game.question(game, 0)

    {:reply, question, %{state | game: game}}
  end

  def handle_call({:question, number}, _from, state) do
    question = Game.question(state.game, number - 1)

    {:reply, question, state}
  end

  def handle_call({:add_message, sender, text}, _from, %{chat: chat} = state) do
    chat = Chat.add_message(chat, sender, text)
    message = Chat.message(chat, chat.length - 1)

    {:reply, message, %{state | chat: chat}}
  end

  def handle_call(:chat, _from, %{chat: chat} = state) do
    {:reply, chat, state}
  end

  defp via(name) do
    {:via, Registry, {Trivia.GameRegistry, name}}
  end
end

defmodule Trivia.GameSupervisor do
  use DynamicSupervisor

  alias DynamicSupervisor, as: Supervisor
  alias Trivia.GameServer

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(name) do
    with {:ok, pid} <- Supervisor.start_child(__MODULE__, {GameServer, name}) do
      {:ok, pid}
    else
      error -> error
    end
  end

  def init(_) do
    Supervisor.init(strategy: :one_for_one)
  end
end

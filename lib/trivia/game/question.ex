defmodule Trivia.Question do
  defstruct votes: %{a: 0, b: 0, c: 0}, total: 0

  def new do
    %__MODULE__{}
  end

  def vote(%__MODULE__{total: t, votes: v} = question, answer, strength) do
    %{question | total: t + 1, votes: Map.update!(v, answer, &(&1 + strength))}
  end

  def votes(%__MODULE__{votes: votes}, answer) do
    Map.get(votes, answer)
  end
end
 

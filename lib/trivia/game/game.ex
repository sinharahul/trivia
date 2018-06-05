defmodule Trivia.Game do
  alias Trivia.Question

  defstruct questions: [], length: 0

  def new do
    %__MODULE__{questions: [Question.new()], length: 1}
  end

  def add_question(%__MODULE__{questions: questions, length: length} = game) do
    %{game | questions: questions ++ [Question.new()], length: length + 1}
  end

  def vote(%__MODULE__{questions: questions} = game, index, answer, strength) do
    %{game | questions: List.update_at(questions, index, &(Question.vote(&1, answer, strength)))}
  end

  def question(%__MODULE__{questions: questions}, index) do
    Enum.at(questions, index)
  end
end

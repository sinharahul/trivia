defmodule Trivia.QuestionTest do
  use ExUnit.Case

  alias Trivia.Question

  setup do
    {:ok, question: Question.new()}
  end

  describe "new/1" do
    test "it returns a Question struct" do
      assert Question.new() == %Question{}
    end
  end

  describe "vote/3" do
    test "it updates the votes for a particular answer", %{question: question} do
      assert Question.vote(question, :a, 5).votes.a == 5
    end

    test 'it can update the same answer multiple times', %{question: question} do
      question = question
        |> Question.vote(:a, 5)
        |> Question.vote(:a, 5)

      assert question.votes.a == 10
    end

    test 'it can update multiple answers', %{question: question} do
      question = question
        |> Question.vote(:a, 5)
        |> Question.vote(:b, 10)
        |> Question.vote(:c, 15)

      assert question.votes == %{a: 5, b: 10, c: 15}
    end

    test 'it updates the total to match the number of votes', %{question: question} do
      question = question
        |> Question.vote(:a, 5)
        |> Question.vote(:b, 10)
        |> Question.vote(:c, 15)

      assert question.total == 3
    end
  end

  describe "votes/2" do
    test "it shows the votes for a particular answers", %{question: question} do
      question = question |> Question.vote(:a, 5)

      assert Question.votes(question, :a) == 5
    end
  end
end

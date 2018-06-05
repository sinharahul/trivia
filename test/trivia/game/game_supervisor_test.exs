defmodule Trivia.GameSupervisorTest do
  use ExUnit.Case
  use Trivia.Unique

  alias Trivia.GameSupervisor

  setup do
    {:ok, %{children: count_children()}}
  end

  describe "start_child/1" do
    test "it adds a new game under supervision", ctx do
      GameSupervisor.start_child(ctx.game)
      assert count_children() - ctx.children == 1
    end

    test "it will not start two games with the game name", ctx do
      {:ok, pid} = GameSupervisor.start_child(ctx.game)
      second_attempt = GameSupervisor.start_child(ctx.game)

      assert {:error, {:already_started, ^pid}} = second_attempt
      refute count_children() - ctx.children == 2
    end
  end

  defp count_children, do: DynamicSupervisor.count_children(GameSupervisor).active
end

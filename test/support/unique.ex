defmodule Trivia.Unique do
  use ExUnit.CaseTemplate

  def get_unique do
    to_string(:os.system_time(:nano_seconds))
  end

  setup do
    {:ok, %{game: get_unique()}}
  end
end

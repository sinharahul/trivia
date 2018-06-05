defmodule Trivia.MessageTest do
  use ExUnit.Case

  alias Trivia.Message


  describe "new/2" do
    test "it returns a Message struct with sender and text sent" do
      message = Message.new("Matt", "test")

      assert message.sender == "Matt"
      assert message.text == "test"
    end

    test "it also sets a timestamp to a the current DateTime" do
      message = Message.new("Matt", "test")

      assert message.timestamp.__struct__ == DateTime
    end
  end
end

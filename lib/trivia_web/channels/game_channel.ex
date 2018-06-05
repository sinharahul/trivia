defmodule TriviaWeb.GameChannel do
  use TriviaWeb, :channel

  intercept ["new_vote", "reset"]

  def join("game:" <> game, _params, socket) do
    socket = socket
      |> assign(:game, game)
      |> assign(:question, 1)

    chat = Trivia.chat(game)
    question = Trivia.question(game, 1)

    {:ok, %{question: question, chat: chat}, socket}
  end

  def handle_in("next", _params, %{assigns: %{game: game}} = socket) do
    socket = assign(socket, :question, socket.assigns.question + 1)

    question = case Trivia.question(game, socket.assigns.question) do
      nil ->
        Trivia.add_question(game)

      question ->
        question
    end

    {:reply, {:ok, %{question: question}}, socket}
  end

  def handle_in("back", _params, %{assigns: %{game: game}} = socket) do
    {question, socket} = case socket.assigns.question do
      1 ->
        {Trivia.question(game, 1), socket}

      num ->
        {Trivia.question(game, num - 1), assign(socket, :question, num - 1)}
    end

    {:reply, {:ok, %{question: question}}, socket}
  end

  def handle_in("vote", %{"answer" => answer, "strength" => strength}, s) do
    answer = String.to_existing_atom(answer)
    strength = String.to_integer(strength)

    question = Trivia.vote(s.assigns.game, s.assigns.question, answer, strength)

    broadcast(s, "new_vote", %{question: question, number: s.assigns.question})
    {:noreply, s}
  end

  def handle_in("new_message", %{"sender" => sender, "text" => text}, socket) do
    message = Trivia.add_message(socket.assigns.game, sender, text)

    broadcast(socket, "new_message", %{message: message})
    {:noreply, socket}
  end

  def handle_in("propose_reset", _params, socket) do
    broadcast(socket, "reset_proposed", %{})
    {:noreply, socket}
  end

  def handle_in("reject_reset", _params, socket) do
    broadcast(socket, "reset_rejected", %{})
    {:noreply, socket}
  end

  def handle_in("reset", _params, %{assigns: assigns} = socket) do
    broadcast(socket, "reset", %{question: Trivia.reset(assigns.game)})
    {:noreply, socket}
  end

  def handle_out("reset", msg, socket) do
    socket = assign(socket, :question, 1)
    push(socket, "reset", msg)

    {:noreply, socket}
  end

  def handle_out("new_vote", %{question: question, number: number}, socket) do
    case socket.assigns.question do
      ^number ->
        push socket, "new_vote", %{question: question}
        {:noreply, socket}

      _number ->
        {:noreply, socket}
    end
  end
end

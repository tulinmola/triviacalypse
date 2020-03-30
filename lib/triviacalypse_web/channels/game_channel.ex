defmodule TriviacalypseWeb.GameChannel do
  use TriviacalypseWeb, :channel

  alias Triviacalypse.Player
  alias TriviacalypseWeb.{GameView, QuestionView}

  @type topic :: binary
  @type event :: binary
  @type socket :: Phoenix.Socket.t()

  @impl true
  @spec join(topic, map, socket) :: {:ok, map, socket} | {:error, reason :: map}
  def join("game:lobby", _payload, socket) do
    games = Triviacalypse.list_games()

    response = %{
      games: Enum.map(games, &render_game/1)
    }

    {:ok, response, socket}
  end

  def join("game:" <> id, %{"user_id" => user_id, "username" => username}, socket) do
    case Triviacalypse.get_game(id) do
      {:ok, pid} ->
        player = %Player{id: user_id, username: username}
        send(self(), {:after_join, player})

        players =
          pid
          |> Triviacalypse.list_players()
          |> Map.new(&{&1.id, &1})

        game =
          pid
          |> Triviacalypse.GameServer.game()
          |> Map.put(:players, players)

        question = Triviacalypse.GameServer.question(pid)

        response = %{
          game: render_game(game),
          question: render_question(question)
        }

        socket =
          socket
          |> assign(:game_id, id)
          |> assign(:player_id, user_id)

        {:ok, response, socket}

      {:error, :not_found} ->
        {:error, %{reason: "not_found"}}
    end
  end

  @impl true
  @spec handle_in(binary, map, socket) :: {:noreply, socket}
  def handle_in("answer", %{"value" => value}, socket) do
    Triviacalypse.answer_game(socket.assigns.game_id, socket.assigns.player_id, value)
    {:noreply, socket}
  end

  @impl true
  @spec handle_info(any, socket) :: {:noreply, socket}
  def handle_info({:after_join, player}, socket) do
    Triviacalypse.add_player(socket.assigns.game_id, player)
    {:noreply, socket}
  end

  defp render_game(game) do
    GameView.render("game.json", %{game: game})
  end

  defp render_question(nil), do: nil

  defp render_question(question) do
    QuestionView.render("question.json", %{question: question})
  end
end

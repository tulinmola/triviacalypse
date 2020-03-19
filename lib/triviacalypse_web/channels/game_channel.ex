defmodule TriviacalypseWeb.GameChannel do
  use TriviacalypseWeb, :channel

  alias Triviacalypse.Player
  alias TriviacalypseWeb.GameView

  @type topic :: binary
  @type event :: binary
  @type socket :: Phoenix.Socket.t()

  @impl true
  @spec join(topic, map, socket) :: {:ok, map, socket} | {:error, reason :: map}
  def join("game:lobby", _payload, socket) do
    games = Triviacalypse.list_games()

    response = %{
      games: Enum.map(games, &GameView.render("game.json", %{game: &1}))
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
          |> Triviacalypse.list_game_players()
          |> Map.new(&{&1.id, &1})

        game =
          pid
          |> Triviacalypse.GameServer.game()
          |> Map.put(:players, players)

        response = GameView.render("game.json", %{game: game})

        socket =
          socket
          |> assign(:game_id, id)
          |> assign(:user_id, user_id)

        {:ok, response, socket}

      {:error, :not_found} ->
        {:error, %{reason: "not_found"}}
    end
  end

  @impl true
  @spec handle_info(any, socket) :: {:noreply, socket}
  def handle_info({:after_join, player}, socket) do
    Triviacalypse.add_game_player(socket.assigns.game_id, player)
    {:noreply, socket}
  end
end

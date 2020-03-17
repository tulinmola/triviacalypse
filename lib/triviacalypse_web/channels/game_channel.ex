defmodule TriviacalypseWeb.GameChannel do
  use TriviacalypseWeb, :channel

  alias Triviacalypse.Player
  alias TriviacalypseWeb.{GameView, PlayerView}

  @type topic :: binary
  @type event :: binary
  @type socket :: Phoenix.Socket.t()

  @impl true
  @spec join(topic, map, socket) :: {:ok, map, socket}
  def join("game:lobby", _payload, socket) do
    games = Triviacalypse.list_games()

    response = %{
      games: Enum.map(games, &GameView.render("game.json", %{game: &1}))
    }

    {:ok, response, socket}
  end

  def join("game:" <> game_id, %{"user_id" => user_id, "username" => username}, socket) do
    player = %Player{id: user_id, username: username}
    send(self(), {:after_join, player})

    players =
      game_id
      |> Triviacalypse.list_game_players()
      |> Enum.map(&PlayerView.render("player.json", %{player: &1}))

    response = %{
      players: players
    }

    socket =
      socket
      |> assign(:game_id, game_id)
      |> assign(:user_id, user_id)

    {:ok, response, socket}
  end

  @impl true
  @spec handle_info(any, socket) :: {:noreply, socket}
  def handle_info({:after_join, player}, socket) do
    Triviacalypse.add_game_player(socket.assigns.game_id, player)
    {:noreply, socket}
  end
end

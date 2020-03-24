defmodule TriviacalypseWeb.GameView do
  use TriviacalypseWeb, :view

  alias TriviacalypseWeb.{GameView, PlayerView}

  def render("create.json", %{id: id}) do
    %{status: "created", data: %{id: id}}
  end

  def render("show.json", %{game: game}) do
    %{data: render_one(game, GameView, "game.json")}
  end

  def render("game.json", %{game: game}) do
    players = Map.values(game.players)

    %{
      id: game.id,
      status: game.status,
      creator_id: game.creator_id,
      creator_username: game.creator_username,
      player_count: game.player_count,
      players: render_many(players, PlayerView, "player.json"),
      inserted_at: DateTime.to_unix(game.inserted_at, :millisecond)
    }
  end
end

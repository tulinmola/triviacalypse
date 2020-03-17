defmodule TriviacalypseWeb.GameView do
  use TriviacalypseWeb, :view

  alias TriviacalypseWeb.GameView

  def render("show.json", %{game: game}) do
    %{data: render_one(game, GameView, "game.json")}
  end

  def render("game.json", %{game: game}) do
    %{id: game.id, player_count: game.player_count}
  end
end

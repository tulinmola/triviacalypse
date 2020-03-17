defmodule TriviacalypseWeb.PlayerView do
  use TriviacalypseWeb, :view

  def render("player.json", %{player: player}) do
    %{id: player.id, username: player.username, score: player.score}
  end
end

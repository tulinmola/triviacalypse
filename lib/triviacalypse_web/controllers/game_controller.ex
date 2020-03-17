defmodule TriviacalypseWeb.GameController do
  use TriviacalypseWeb, :controller

  @type conn :: Plug.Conn.t()

  @spec create(conn, map) :: conn
  def create(conn, %{"game" => game_params}) do
    with {:ok, game} <- Triviacalypse.create_game(game_params) do
      conn
      |> put_status(:created)
      |> render("show.json", game: game)
    end
  end
end

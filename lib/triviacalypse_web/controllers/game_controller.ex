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

  @spec delete(conn, map) :: conn
  def delete(conn, %{"id" => id}) do
    with {:ok, _game} <- Triviacalypse.delete_game(id) do
      send_resp(conn, :no_content, "")
    end
  end
end

defmodule TriviacalypseWeb.StartController do
  use TriviacalypseWeb, :controller

  alias TriviacalypseWeb.GameView

  @type conn :: Plug.Conn.t()

  action_fallback TriviacalypseWeb.FallbackController

  @spec create(conn, map) :: conn
  def create(conn, %{"game_id" => game_id, "game" => game_params}) do
    with :ok <- Triviacalypse.start_game(game_id, game_params) do
      conn
      |> put_status(:created)
      |> put_view(GameView)
      |> render("create.json", id: game_id)
    end
  end
end

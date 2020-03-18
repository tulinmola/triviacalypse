defmodule TriviacalypseWeb.StartControllerTest do
  use TriviacalypseWeb.ConnCase

  alias Triviacalypse.{Fixtures, GameRepo}

  setup %{} do
    GameRepo.delete_all()
  end

  test "starts game when existing", %{conn: conn} do
    game = Fixtures.create_game()
    game_id = game.id

    conn = post(conn, Routes.game_start_path(conn, :create, game_id))

    assert %{"id" => ^game_id} = json_response(conn, 201)["data"]
  end

  test "renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, Routes.game_start_path(conn, :create, "not-existing-id"))
    assert json_response(conn, 404)
  end
end

defmodule TriviacalypseWeb.StartControllerTest do
  use TriviacalypseWeb.ConnCase

  alias Triviacalypse.{Fixtures, GameRepo}
  alias TriviacalypseWeb.Endpoint
  alias Phoenix.Socket.Broadcast

  @lobby_topic "game:lobby"

  setup %{} do
    GameRepo.delete_all()
  end

  test "starts game when existing", %{conn: conn} do
    Endpoint.subscribe(@lobby_topic)

    game = Fixtures.create_game()
    game_id = game.id

    conn = post(conn, Routes.game_start_path(conn, :create, game_id), game: %{"type" => "large"})

    assert %{"id" => ^game_id} = json_response(conn, 201)["data"]

    assert_receive %Broadcast{
      topic: @lobby_topic,
      event: "game",
      payload: %{id: ^game_id, type: "large"}
    }
  end

  test "renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, Routes.game_start_path(conn, :create, "not-existing-id"), game: %{})
    assert json_response(conn, 404)
  end
end

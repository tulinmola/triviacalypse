defmodule TriviacalypseWeb.GameControllerTest do
  use TriviacalypseWeb.ConnCase

  alias Triviacalypse.GameRepo

  @create_attrs %{
    "creator_id" => UUID.uuid4(),
    "creator_username" => "test-username"
  }

  setup %{} do
    GameRepo.delete_all()
  end

  describe "create game" do
    test "renders game when data is valid", %{conn: conn} do
      conn = post(conn, Routes.game_path(conn, :create), game: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      pid = GameRepo.get(id)
      assert is_pid(pid)
    end
  end
end

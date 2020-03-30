defmodule TriviacalypseWeb.GameControllerTest do
  use TriviacalypseWeb.ConnCase

  alias Triviacalypse.{Fixtures, GameRepo}
  alias TriviacalypseWeb.Endpoint
  alias Phoenix.Socket.Broadcast

  @lobby_topic "game:lobby"

  @create_attrs %{
    "creator_id" => UUID.uuid4(),
    "creator_username" => "test-username"
  }

  setup %{} do
    GameRepo.delete_all()
  end

  describe "create game" do
    test "renders game when data is valid", %{conn: conn} do
      Endpoint.subscribe(@lobby_topic)

      conn = post(conn, Routes.game_path(conn, :create), game: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      pid = GameRepo.get(id)
      assert is_pid(pid)

      assert_receive %Broadcast{
        topic: @lobby_topic,
        event: "game",
        payload: %{id: ^id, creator_username: "test-username"}
      }
    end
  end

  describe "delete game" do
    setup [:create_chart]

    test "deletes chosen game", %{conn: conn, game: game} do
      game_id = game.id

      Endpoint.subscribe(@lobby_topic)
      topic = "game:#{game_id}"
      Endpoint.subscribe(topic)

      ref =
        game_id
        |> Triviacalypse.get_game!()
        |> Process.monitor()

      conn = delete(conn, Routes.game_path(conn, :delete, game))

      assert response(conn, 204)

      assert_receive %Broadcast{
        topic: @lobby_topic,
        event: "delete",
        payload: %{id: ^game_id}
      }

      assert_receive %Broadcast{
        topic: topic,
        event: "delete",
        payload: %{}
      }

      receive do
        {:DOWN, ^ref, _, _, _} -> :ok
      end
    end
  end

  defp create_chart(_) do
    {:ok, game} =
      Fixtures.create_game()
      |> Triviacalypse.create_game()

    {:ok, game: game}
  end
end

defmodule TriviacalypseWeb.GameChannelTest do
  use TriviacalypseWeb.ChannelCase

  alias Triviacalypse.Fixtures
  alias TriviacalypseWeb.{GameChannel, UserSocket}

  setup %{} do
    Triviacalypse.GameRepo.delete_all()
  end

  test "joning to lobby gets all games" do
    first = Fixtures.create_game()
    second = Fixtures.create_game()

    assert {:ok, %{games: games}, socket} =
             UserSocket
             |> socket("user_id", %{some: :assign})
             |> subscribe_and_join(GameChannel, "game:lobby")

    assert Enum.count(games) == 2
    assert Enum.find(games, &(&1.id == first.id))
    assert Enum.find(games, &(&1.id == second.id))
  end

  test "joning game gets all players and adds the new one" do
    first = Fixtures.create_player()
    second = Fixtures.create_player()
    game = Fixtures.create_game(%{players: [first, second]})

    payload = %{user_id: UUID.uuid4(), username: "test"}

    assert {:ok, %{game: %{players: players}}, socket} =
             UserSocket
             |> socket("user_id", %{some: :assign})
             |> subscribe_and_join(GameChannel, "game:#{game.id}", payload)

    assert Enum.count(players) == 2
    assert Enum.find(players, &(&1.id == first.id))
    assert Enum.find(players, &(&1.id == second.id))
  end
end

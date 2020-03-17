defmodule Triviacalypse.GameRepoTest do
  use ExUnit.Case

  alias Triviacalypse.{Game, GameRepo, GameServer}

  setup %{} do
    GameRepo.delete_all()
  end

  test "insert new game" do
    id = UUID.uuid4()
    assert {:ok, pid} = GameRepo.insert(%Game{id: id})
    game = GameServer.game(pid)
    assert id == game.id
  end

  test "get game by id" do
    pid = create_game()
    game = GameServer.game(pid)
    assert pid == GameRepo.get(game.id)
  end

  defp create_game do
    {:ok, pid} = GameRepo.insert(%Game{id: UUID.uuid4()})
    pid
  end
end

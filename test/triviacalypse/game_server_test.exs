defmodule Triviacalypse.GameServerTest do
  use ExUnit.Case

  alias Triviacalypse.{Game, GameServer, Player}
  alias TriviacalypseWeb.Endpoint
  alias Phoenix.Socket.Broadcast

  @lobby_topic "game:lobby"

  test "creating game broadcasts to lobby channel" do
    Endpoint.subscribe(@lobby_topic)

    %{game: game} = create_game()
    id = game.id

    assert_receive %Broadcast{topic: @lobby_topic, event: "add_game", payload: %{id: ^id}}
  end

  test "add player broadcasts to game channel and lobby" do
    Endpoint.subscribe(@lobby_topic)
    %{pid: pid, game: game, topic: topic} = create_game()

    player = create_player()

    GameServer.add_player(pid, player)

    player_id = player.id
    game_id = game.id

    assert_receive %Broadcast{topic: ^topic, event: "add_player", payload: %{id: ^player_id}}

    assert_receive %Broadcast{
      topic: @lobby_topic,
      event: "update_game",
      payload: %{id: ^game_id, player_count: 1}
    }
  end

  test "get all players in a game" do
    first = create_player()
    second = create_player()
    %{pid: pid} = create_game([first, second])

    players = GameServer.players(pid)

    assert Enum.count(players) == 2
    assert Enum.find(players, &(&1.id == first.id))
    assert Enum.find(players, &(&1.id == second.id))
  end

  defp create_game(players \\ []) do
    id = UUID.uuid4()
    game = %Game{id: id, player_count: length(players), players: Map.new(players, &{&1.id, &1})}
    topic = "game:#{id}"

    {:ok, pid} = GameServer.start_link(game: game)
    Endpoint.subscribe(topic)

    %{pid: pid, game: game, topic: topic}
  end

  defp create_player() do
    %Player{id: UUID.uuid4()}
  end
end

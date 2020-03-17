defmodule Triviacalypse.Game do
  alias Triviacalypse.{Game, Player}

  @type player :: Player.t()

  @type t :: %Game{
          id: binary,
          player_count: integer,
          players: map
        }

  defstruct id: "", player_count: 0, players: %{}

  @spec new(map) :: t
  def new(_attrs) do
    %Game{id: UUID.uuid4()}
  end

  @spec add_player(t, player) :: t
  def add_player(game, player) do
    players = Map.put_new(game.players, player.id, player)
    player_count = game.player_count + 1

    %Game{game | players: players, player_count: player_count}
  end

  @spec player?(t, player | binary) :: boolean
  def player?(game, %Player{} = player), do: player?(game, player.id)

  def player?(game, player_id) do
    Map.has_key?(game.players, player_id)
  end
end

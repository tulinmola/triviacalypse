defmodule Triviacalypse.Game do
  alias Triviacalypse.{Game, Player}

  @type status :: :waiting | :playing | :finished
  @type player :: Player.t()
  @type datetime :: DateTime.t()

  @type t :: %Game{
          id: binary,
          status: status,
          creator_id: binary,
          creator_username: binary,
          inserted_at: datetime,
          player_count: integer,
          players: map
        }

  @default_inserted_at {{2020, 1, 30}, {0, 0, 0}}
                       |> NaiveDateTime.from_erl!()
                       |> DateTime.from_naive!("Etc/UTC")

  defstruct id: "",
            status: :waiting,
            creator_id: "",
            creator_username: "",
            inserted_at: @default_inserted_at,
            player_count: 0,
            players: %{}

  @spec new(map) :: t
  def new(attrs) do
    %Game{
      id: UUID.uuid4(),
      creator_id: Map.get(attrs, "creator_id", ""),
      creator_username: Map.get(attrs, "creator_username", "Annonymous")
    }
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

  @spec update_status(t, status) :: t
  def update_status(%Game{status: :waiting} = game, :playing) do
    %Game{game | status: :playing}
  end

  def update_status(%Game{status: :playing} = game, :finished) do
    %Game{game | status: :ended}
  end
end

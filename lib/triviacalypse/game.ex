defmodule Triviacalypse.Game do
  alias Triviacalypse.{Game, Player}

  @type status :: :waiting | :playing | :finished
  @type game_type :: :small | :medium | :large
  @type player :: Player.t()
  @type datetime :: DateTime.t()

  @type t :: %Game{
          id: binary,
          type: game_type,
          status: status,
          creator_id: binary,
          creator_username: binary,
          inserted_at: datetime,
          player_count: integer,
          players: map
        }

  @small_question_count 10
  @medium_question_count 25
  @large_question_count 70

  @valid_string_types ~w(small medium large)

  @default_inserted_at {{2020, 1, 30}, {0, 0, 0}}
                       |> NaiveDateTime.from_erl!()
                       |> DateTime.from_naive!("Etc/UTC")

  defstruct id: "",
            type: :medium,
            status: :waiting,
            creator_id: "",
            creator_username: "",
            inserted_at: @default_inserted_at,
            player_count: 0,
            players: %{}

  @spec new(map) :: t
  def new(attrs) do
    update(%Game{id: UUID.uuid4()}, attrs)
  end

  @spec question_count(t) :: integer
  def question_count(%Game{type: :small}), do: @small_question_count

  def question_count(%Game{type: :medium}), do: @medium_question_count

  def question_count(%Game{type: :large}), do: @large_question_count

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

  @spec start(t, map) :: t
  def start(%Game{status: :waiting} = game, attrs) do
    game
    |> update(attrs)
    |> Map.put(:status, :playing)
  end

  @spec finish(t) :: t
  def finish(%Game{status: :playing} = game) do
    %Game{game | status: :finished}
  end

  defp update(game, attrs) do
    Enum.reduce(attrs, game, fn {key, value}, game ->
      key = String.to_existing_atom(key)
      value = convert(key, value)
      Map.update!(game, key, fn _ -> value end)
    end)
  end

  defp convert(:type, type) when type in @valid_string_types do
    String.to_atom(type)
  end

  defp convert(_key, value), do: value
end

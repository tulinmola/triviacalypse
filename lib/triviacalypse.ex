defmodule Triviacalypse do
  alias Triviacalypse.{Game, GameRepo, GameServer, Player}

  @type game :: Game.t()
  @type player :: Player.t()

  @spec list_games :: [game]
  def list_games do
    GameRepo.all()
    |> Enum.map(&GameServer.game/1)
  end

  @spec create_game(game | map) :: {:ok, game} | {:error, any}
  def create_game(%Game{} = game) do
    case GameRepo.insert(game) do
      {:ok, pid} -> {:ok, GameServer.game(pid)}
      {:error, error} -> {:error, error}
    end
  end

  def create_game(attrs) do
    attrs
    |> Game.new()
    |> create_game()
  end

  @spec delete_game(binary) :: {:ok, game}
  def delete_game(id) do
    case get_game(id) do
      {:ok, pid} ->
        game = GameServer.game(pid)
        :ok = GameServer.kill(pid)
        {:ok, game}

      {:error, error} ->
        {:error, error}
    end
  end

  @spec start_game(binary) :: :ok | {:error, any}
  def start_game(id) do
    case get_game(id) do
      {:ok, pid} -> GameServer.start(pid)
      {:error, error} -> {:error, error}
    end
  end

  @spec get_game(binary) :: {:ok, pid} | {:error, any}
  def get_game(id) do
    case GameRepo.get(id) do
      :undefined -> {:error, :not_found}
      pid -> {:ok, pid}
    end
  end

  @spec get_game!(binary) :: pid
  def get_game!(id) do
    {:ok, game} = get_game(id)
    game
  end

  @spec list_players(binary | pid) :: [player]
  def list_players(game_id) when is_binary(game_id) do
    game_id
    |> get_game!()
    |> list_players()
  end

  def list_players(game) do
    GameServer.players(game)
  end

  @spec add_player(binary, player) :: player
  def add_player(game_id, player) do
    game_id
    |> get_game!()
    |> GameServer.add_player(player)
  end

  @spec answer_game(binary, binary, binary) :: :ok
  def answer_game(game_id, player_id, value) do
    game_id
    |> get_game!()
    |> GameServer.answer(player_id, value)
  end
end

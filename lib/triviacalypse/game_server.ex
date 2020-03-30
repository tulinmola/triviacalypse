defmodule Triviacalypse.GameServer do
  use GenServer, restart: :transient

  alias Triviacalypse.{Game, Gameplay, GameServer, Player, Question}

  @type game :: Game.t()
  @type player :: Player.t()
  @type question :: Question.t()
  @type gameplay :: Gameplay.t()

  @spec start_link([{:game, game}]) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    game = Keyword.get(opts, :game)
    GenServer.start_link(GameServer, game, opts)
  end

  @spec add_player(pid, player) :: player
  def add_player(pid, player) do
    GenServer.call(pid, {:add_player, player})
  end

  @spec players(pid) :: [player]
  def players(pid) do
    GenServer.call(pid, :players)
  end

  @spec game(pid) :: game
  def game(pid) do
    GenServer.call(pid, :game)
  end

  @spec question(pid) :: question | nil
  def question(pid) do
    GenServer.call(pid, :question)
  end

  @spec start(pid, map) :: :ok
  def start(pid, attrs \\ %{}) do
    GenServer.cast(pid, {:start, attrs})
  end

  @spec answer(pid, binary, binary) :: :ok
  def answer(pid, player_id, value) do
    GenServer.cast(pid, {:answer, player_id, value})
  end

  @spec kill(pid) :: :ok
  def kill(pid) do
    GenServer.call(pid, :kill)
  end

  @impl true
  @spec init(game) :: {:ok, gameplay}
  def init(game) do
    {:ok, Gameplay.new(game)}
  end

  @impl true
  def handle_call(:players, _from, state) do
    # TODO if there are a million players this should return only
    # a couple of them and a precalculated count.
    players = Map.values(state.game.players)
    {:reply, players, state}
  end

  @impl true
  def handle_call({:add_player, player}, _from, state) do
    {:reply, player, Gameplay.add_player(state, player)}
  end

  @impl true
  def handle_call(:game, _from, state) do
    response = %Game{state.game | players: %{}}
    {:reply, response, state}
  end

  @impl true
  def handle_call(:question, _from, state) do
    {:reply, state.question, state}
  end

  @impl true
  def handle_call(:kill, _from, state) do
    {:stop, :normal, Gameplay.delete(state), state}
  end

  @impl true
  def handle_cast({:start, attrs}, state) do
    {:noreply, Gameplay.start(state, attrs)}
  end

  @impl true
  def handle_cast({:answer, player_id, value}, state) do
    {:noreply, Gameplay.answer(state, player_id, value)}
  end

  @impl true
  def handle_info(:new_question, state) do
    {:noreply, Gameplay.new_question(state)}
  end

  @impl true
  def terminate(_reason, _state) do
    # IO.inspect({:terminate, reason, state})
  end
end

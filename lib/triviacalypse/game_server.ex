defmodule Triviacalypse.GameServer do
  use GenServer, restart: :transient

  alias Triviacalypse.{Game, GameServer, Player, QuestionPool}
  alias TriviacalypseWeb.{Endpoint, GameView, PlayerView, QuestionView}

  @type game :: Game.t()
  @type player :: Player.t()

  @type t :: %GameServer{
          game: game,
          topic: binary
        }

  defstruct [:game, :topic]

  @lobby_topic "game:lobby"

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

  @spec start(pid) :: :ok
  def start(pid) do
    GenServer.cast(pid, :start)
  end

  @spec kill(pid) :: :ok
  def kill(pid) do
    GenServer.call(pid, :kill)
  end

  @impl true
  @spec init(game) :: {:ok, t}
  def init(game) do
    topic = "game:#{game.id}"
    server = %GameServer{game: game, topic: topic}

    broadcast_game!(server, game)

    {:ok, server}
  end

  @impl true
  def handle_call(:players, _from, server) do
    # TODO if there are a million players this should return only
    # a couple of them and a precalculated count.
    players = Map.values(server.game.players)
    {:reply, players, server}
  end

  @impl true
  def handle_call({:add_player, player}, _from, server) do
    unless Game.player?(server.game, player) do
      game = Game.add_player(server.game, player)
      broadcast_player!(server, player)
      broadcast_game!(server, game)
      {:reply, player, %GameServer{server | game: game}}
    else
      {:reply, player, server}
    end
  end

  @impl true
  def handle_call(:game, _from, server) do
    response = %Game{server.game | players: %{}}
    {:reply, response, server}
  end

  @impl true
  def handle_call(:kill, _from, server) do
    {:stop, :normal, :ok, server}
  end

  @impl true
  def handle_cast(:start, server) do
    {:ok, question} = QuestionPool.get()
    broadcast_question!(server, question)
    {:noreply, server}
  end

  @impl true
  def terminate(_reason, _server) do
    # IO.inspect({:terminate, reason, server})
  end

  defp broadcast_game!(_server, game) do
    message = GameView.render("game.json", %{game: game})
    :ok = Endpoint.broadcast(@lobby_topic, "game", message)
  end

  defp broadcast_player!(server, player) do
    message = PlayerView.render("player.json", %{player: player})
    :ok = Endpoint.broadcast(server.topic, "player", message)
  end

  defp broadcast_question!(server, question) do
    message = QuestionView.render("question.json", %{question: question})
    :ok = Endpoint.broadcast(server.topic, "question", message)
  end
end

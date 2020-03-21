defmodule TriviacalypseWeb.GameBroadcaster do
  alias Triviacalypse.{Game, Player, Question}
  alias TriviacalypseWeb.{Endpoint, GameView, PlayerView, QuestionView}

  @type game :: Game.t()
  @type player :: Player.t()
  @type question :: Question.t()
  @type topic :: binary

  @lobby_topic "game:lobby"

  @spec topic(game) :: topic
  def topic(game), do: "game:#{game.id}"

  @spec broadcast_game!(game) :: :ok
  def broadcast_game!(game) do
    message = GameView.render("game.json", %{game: game})
    :ok = Endpoint.broadcast(@lobby_topic, "game", message)
  end

  @spec broadcast_player!(game, player) :: :ok
  def broadcast_player!(game, player) do
    topic = topic(game)
    message = PlayerView.render("player.json", %{player: player})
    :ok = Endpoint.broadcast(topic, "player", message)
  end

  @spec broadcast_question!(game, question) :: :ok
  def broadcast_question!(game, question) do
    topic = topic(game)
    message = QuestionView.render("question.json", %{question: question})
    :ok = Endpoint.broadcast(topic, "question", message)
  end

  @spec broadcast_answered!(game, binary) :: :ok
  def broadcast_answered!(game, player_id) do
    topic = topic(game)
    message = %{id: player_id}
    :ok = Endpoint.broadcast(topic, "answered", message)
  end

  @spec broadcast_correct_answer!(game, question, map) :: :ok
  def broadcast_correct_answer!(game, question, counts) do
    topic = topic(game)
    message = %{value: question.correct_answer, counts: counts}
    :ok = Endpoint.broadcast(topic, "correct_answer", message)
  end
end

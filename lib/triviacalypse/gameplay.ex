defmodule Triviacalypse.Gameplay do
  alias Triviacalypse.{Game, Gameplay, Player, Question, QuestionPool}
  alias TriviacalypseWeb.GameBroadcaster, as: Broadcaster

  @type game :: Game.t()
  @type player :: Player.t()
  @type question :: Question.t()

  @type t :: %Gameplay{
          game: game,
          question_count: integer,
          question: question | nil,
          answers: map,
          answer_count: integer
        }

  defstruct [:game, :question_count, :question, :answers, :answer_count]

  @time_between_questions 5_000

  @spec new(game) :: t
  def new(game) do
    question_count = Game.question_count(game)

    gameplay = %Gameplay{
      game: game,
      question_count: question_count,
      answers: %{},
      answer_count: 0
    }

    Broadcaster.broadcast_game!(game)
    gameplay
  end

  @spec delete(t) :: :ok
  def delete(gameplay) do
    Broadcaster.broadcast_delete!(gameplay.game)
    :ok
  end

  @spec add_player(t, player) :: t
  def add_player(gameplay, player) do
    unless Game.player?(gameplay.game, player) do
      game = Game.add_player(gameplay.game, player)
      Broadcaster.broadcast_player!(game, player)
      Broadcaster.broadcast_game!(game)
      %Gameplay{gameplay | game: game}
    else
      gameplay
    end
  end

  @spec start(t, map) :: t
  def start(%{game: %{status: :waiting}} = gameplay, attrs) do
    game = Game.start(gameplay.game, attrs)

    Broadcaster.broadcast_game!(game)
    Process.send_after(self(), :new_question, 0)

    question_count = Game.question_count(game)
    %Gameplay{gameplay | game: game, question_count: question_count}
  end

  def start(gameplay), do: gameplay

  @spec answer(t, binary, binary) :: t
  def answer(gameplay, player_id, value) do
    gameplay.answers
    |> Map.get_and_update(player_id, fn current_value ->
      {current_value, value}
    end)
    |> case do
      {nil, answers} ->
        gameplay
        |> add_new_answer(player_id, answers)
        |> check_answers()

      {_old_answer, answers} ->
        %Gameplay{gameplay | answers: answers}
    end
  end

  defp add_new_answer(gameplay, player_id, answers) do
    answer_count = gameplay.answer_count + 1
    Broadcaster.broadcast_answered!(gameplay.game, player_id)
    %Gameplay{gameplay | answers: answers, answer_count: answer_count}
  end

  defp check_answers(%Gameplay{answer_count: count, game: %{player_count: count}} = gameplay) do
    %{game: game, answers: answers, question: question} = gameplay
    %{correct_answer: correct_answer, score: score} = question

    {players, counts} =
      Enum.reduce(answers, {game.players, %{}}, fn {player_id, answer}, {players, counts} ->
        players =
          if answer == correct_answer do
            player =
              game.players
              |> Map.get(player_id)
              |> Player.add_score(score)

            Broadcaster.broadcast_player!(game, player)

            Map.put(players, player_id, player)
          else
            players
          end

        {players, Map.update(counts, answer, 1, &(&1 + 1))}
      end)

    Broadcaster.broadcast_correct_answer!(game, question, counts)
    Process.send_after(self(), :new_question, @time_between_questions)

    %Gameplay{gameplay | game: %Game{gameplay.game | players: players}}
  end

  defp check_answers(gameplay), do: gameplay

  @spec new_question(t) :: t
  def new_question(%Gameplay{question_count: 0} = gameplay) do
    game = Game.finish(gameplay.game)

    Broadcaster.broadcast_game!(game)
    Broadcaster.broadcast_finish!(game)

    %Gameplay{gameplay | game: game, question: nil, answers: %{}}
  end

  def new_question(gameplay) do
    {:ok, question} = QuestionPool.get()
    # TODO send error when no available question? This could
    # happen if question service fails even to retries.

    count = gameplay.question_count - 1
    Broadcaster.broadcast_question!(gameplay.game, question)

    %Gameplay{gameplay | question: question, question_count: count, answers: %{}, answer_count: 0}
  end
end

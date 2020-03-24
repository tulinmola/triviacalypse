defmodule Triviacalypse.Gameplay do
  alias Triviacalypse.{Game, Gameplay, Player, Question, QuestionPool}
  alias TriviacalypseWeb.GameBroadcaster, as: Broadcaster

  @type game :: Game.t()
  @type player :: Player.t()
  @type question :: Question.t()

  @type t :: %Gameplay{
          game: game,
          question: question | nil,
          answers: map,
          answer_count: integer
        }

  defstruct [:game, :question, :answers, :answer_count]

  @time_between_questions 5_000

  @spec new(game) :: t
  def new(game) do
    gameplay = %Gameplay{game: game, answers: %{}, answer_count: 0}
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

  @spec start(t) :: t
  def start(gameplay) do
    game = Game.update_status(gameplay.game, :playing)

    Process.send_after(self(), :new_question, 0)

    %Gameplay{gameplay | game: game}
  end

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
  def new_question(gameplay) do
    {:ok, question} = QuestionPool.get()
    # TODO send error when no available question? This could
    # happen if question service fails even to retries.

    Broadcaster.broadcast_question!(gameplay.game, question)

    %Gameplay{gameplay | question: question, answers: %{}, answer_count: 0}
  end
end

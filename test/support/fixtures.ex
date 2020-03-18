defmodule Triviacalypse.Fixtures do
  alias Triviacalypse.{Game, Question, Player}

  @type game :: Game.t()
  @type player :: Player.t()
  @type question :: Question.t()

  @spec create_game([player]) :: game
  def create_game(players \\ []) do
    {:ok, game} =
      %Game{
        id: UUID.uuid4(),
        player_count: length(players),
        players: Map.new(players, &{&1.id, &1})
      }
      |> Triviacalypse.create_game()

    game
  end

  @spec create_player :: player
  def create_player do
    %Player{id: UUID.uuid4(), username: UUID.uuid4()}
  end

  @spec create_question :: question
  def create_question do
    %Question{
      category: "General Knowledge",
      difficulty: "easy",
      text: "test",
      correct_answer: "yes",
      incorrect_answers: ["no"]
    }
  end
end

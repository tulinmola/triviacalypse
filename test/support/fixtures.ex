defmodule Triviacalypse.Fixtures do
  alias Triviacalypse.{Game, Question, Player}

  @type game :: Game.t()
  @type player :: Player.t()
  @type question :: Question.t()

  @spec create_game(map) :: game
  def create_game(attrs \\ %{}) do
    players = Map.get(attrs, :players, [])

    {:ok, game} =
      %Game{
        id: UUID.uuid4(),
        type: :small,
        creator_id: UUID.uuid4(),
        creator_username: "testuser",
        player_count: length(players),
        players: Map.new(players, &{&1.id, &1}),
        inserted_at: now()
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
      score: 1,
      text: "test",
      correct_answer: "yes",
      incorrect_answers: ["no"]
    }
  end

  defp now do
    {:ok, datetime} = DateTime.now("Etc/UTC")
    datetime
  end
end

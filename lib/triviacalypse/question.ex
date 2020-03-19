defmodule Triviacalypse.Question do
  alias Triviacalypse.Question

  @type t :: %Question{
          category: binary,
          difficulty: binary,
          score: integer,
          text: binary,
          correct_answer: binary,
          incorrect_answers: [binary]
        }

  defstruct [:category, :difficulty, :score, :text, :correct_answer, :incorrect_answers]

  @difficulties ~w(easy medium hard)

  @spec new(map) :: t
  def new(%{
        "category" => category,
        "difficulty" => difficulty,
        "question" => text,
        "correct_answer" => correct_answer,
        "incorrect_answers" => incorrect_answers
      }) do
    %Question{
      category: category,
      difficulty: difficulty,
      score: calculate_score(difficulty),
      text: text,
      correct_answer: correct_answer,
      incorrect_answers: incorrect_answers
    }
  end

  defp calculate_score(difficulty) do
    case Enum.find_index(@difficulties, &(&1 == difficulty)) do
      nil -> 1
      index -> index + 1
    end
  end
end

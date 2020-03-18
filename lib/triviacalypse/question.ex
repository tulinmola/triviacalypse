defmodule Triviacalypse.Question do
  alias Triviacalypse.Question

  @type t :: %Question{
          category: binary,
          difficulty: binary,
          text: binary,
          correct_answer: binary,
          incorrect_answers: [binary]
        }

  defstruct [:category, :difficulty, :text, :correct_answer, :incorrect_answers]

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
      type: type,
      difficulty: difficulty,
      text: text,
      correct_answer: correct_answer,
      incorrect_answers: incorrect_answers
    }
  end
end

defmodule Triviacalypse.Question do
  alias Triviacalypse.Question

  defstruct [:category, :type, :difficulty, :text, :correct_answer, :incorrect_answers]

  def new(%{
        "category" => category,
        "type" => type,
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

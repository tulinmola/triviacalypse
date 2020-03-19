defmodule TriviacalypseWeb.QuestionView do
  use TriviacalypseWeb, :view

  def render("question.json", %{question: question}) do
    answers = Enum.shuffle([question.correct_answer | question.incorrect_answers])

    %{
      category: question.category,
      difficulty: question.difficulty,
      score: question.score,
      text: question.text,
      answers: answers
    }
  end
end

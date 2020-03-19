defmodule Triviacalypse.QuestionTestApi do
  alias Triviacalypse.{Fixtures, Question}

  @type question :: Question.t()

  @amount 25

  @spec get :: {:ok, [question]} | {:error, any}
  def get do
    questions = Enum.map(1..@amount, fn _ -> Fixtures.create_question() end)
    {:ok, questions}
  end
end

defmodule Triviacalypse.QuestionTestApi do
  alias Triviacalypse.{Fixtures, Question}

  @type question :: Question.t()

  @spec get :: {:ok, question}
  def get, do: {:ok, Fixtures.create_question()}
end

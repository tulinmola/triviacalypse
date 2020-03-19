defmodule Triviacalypse.OpentdbApi do
  use HTTPoison.Base

  alias Triviacalypse.Question

  @type question :: Question.t()

  @amount 25
  @endpoint "https://opentdb.com"

  @spec get :: {:ok, [question]} | {:error, any}
  def get do
    case get("/api.php?amount=#{@amount}") do
      {:ok, %HTTPoison.Response{body: body}} -> {:ok, body}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  @impl true
  def process_url(url) do
    @endpoint <> url
  end

  @impl true
  def process_response_body(body) do
    body
    |> Jason.decode!()
    |> Map.get("results")
    |> Enum.map(&Question.new/1)
  end
end

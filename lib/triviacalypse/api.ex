defmodule Triviacalypse.Api do
  use HTTPoison.Base

  alias Triviacalypse.Question

  @endpoint "https://opentdb.com/api.php"

  def get do
    case get("?amount=1") do
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
    |> Enum.at(0)
    |> Question.new()
  end
end

defmodule Triviacalypse.Player do
  alias Triviacalypse.Player

  @type question :: Question.t()

  @type t :: %Player{
          id: binary,
          username: binary,
          score: integer
        }

  defstruct id: "", username: "", score: 0

  @spec add_score(t, integer) :: t
  def add_score(player, score) do
    %Player{player | score: player.score + score}
  end
end

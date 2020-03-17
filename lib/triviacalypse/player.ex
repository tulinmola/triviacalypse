defmodule Triviacalypse.Player do
  alias Triviacalypse.Player

  @type t :: %Player{
          id: binary,
          username: binary,
          score: integer
        }

  defstruct id: "", username: "", score: 0
end

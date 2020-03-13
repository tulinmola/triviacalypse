defmodule TriviacalypseWeb.GameChannelTest do
  use TriviacalypseWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      socket(TriviacalypseWeb.UserSocket, "user_id", %{some: :assign})
      |> subscribe_and_join(TriviacalypseWeb.GameChannel, "game:lobby")

    {:ok, socket: socket}
  end
end

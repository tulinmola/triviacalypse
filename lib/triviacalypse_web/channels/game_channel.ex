defmodule TriviacalypseWeb.GameChannel do
  use TriviacalypseWeb, :channel

  alias Triviacalypse.Presence

  def join("game:" <> game_id, %{"user_id" => user_id, "username" => username}, socket) do
    send(self(), :after_join)

    socket =
      socket
      |> assign(:game_id, game_id)
      |> assign(:user_id, user_id)
      |> assign(:username, username)
      |> assign(:topic, "game:#{game_id}")

    {:ok, socket}
  end

  def handle_in("update", %{"username" => username}, socket) do
    update_presence_meta(socket, :username, username)
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game:lobby).
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", Presence.list(socket))

    {:ok, _} =
      Presence.track(socket, socket.assigns.user_id, %{
        online_at: inspect(System.system_time(:second))
      })

    {:noreply, socket}
  end

  defp update_presence_meta(socket, key, value) do
    %{metas: [meta | _rest]} = Presence.get_by_key(socket.assigns.topic, socket.assigns.user_id)
    {:ok, _} = Presence.update(socket, socket.assigns.user_id, Map.put(meta, key, value))
  end
end

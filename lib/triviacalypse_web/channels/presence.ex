defmodule Triviacalypse.Presence do
  use Phoenix.Presence,
    otp_app: :triviacalypse,
    pubsub_server: Triviacalypse.PubSub
end

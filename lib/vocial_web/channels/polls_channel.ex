defmodule VocialWeb.PollsChannel do
  use VocialWeb, :channel

  def join("polls:lobby", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("ping", _payload, socket) do
    broadcast socket, "pong", %{message: "pong"}
    {:reply, {:ok, %{message: "pong"}}, socket}
  end
end

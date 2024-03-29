defmodule WalkieTalkieWeb.Socket do
  use WalkieTalkieWeb, :socket

  channel("room:*", VideoRoomWeb.PeerChannel)
  channel("stats", VideoRoomWeb.StatsChannel)

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end

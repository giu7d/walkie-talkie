defmodule WalkieTalkieWeb.StatsChannel do
  use WalkieTalkieWeb, :channel

  @impl true
  def join("stats", _message, socket) do
    {:ok, socket}
  end
end

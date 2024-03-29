defmodule WalkieTalkie.Room.Monitor do
  use GenServer, restart: :transient

  require Membrane.OpenTelemetry
  require Logger

  def start_link([room_pid, room_id]) do
    GenServer.start_link(__MODULE__, [room_pid, room_id], [])
  end

  @impl true
  def init([room_pid, room_id]) do
    ref = Process.monitor(room_pid)
    {:ok, %{ref: ref, room_pid: room_pid, room_id: room_id}, :hibernate}
  end

  @impl true
  def handle_info(
        {:DOWN, ref, :process, room_pid, reason},
        %{ref: ref, room_pid: room_pid, room_id: room_id} = state
      ) do
    Logger.info("Room: #{room_id} terminated with reason: #{inspect(reason)}")

    room_id
    |> WalkieTalkie.Room.room_span_id()
    |> Membrane.OpenTelemetry.end_span()

    {:stop, :normal, state}
  end
end

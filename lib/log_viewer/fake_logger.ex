defmodule LogViewer.FakeLogger do
  require Logger
  use GenServer

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  @spec init(any) :: {:ok, any}
  def init(state) do
    schedule_call()
    {:ok, state}
  end

  def handle_info(:log, state) do
    Logger.info("test_log")
    schedule_call()
    {:noreply, state}
  end

  defp schedule_call do
    Process.send_after(self(), :log, 1000)
  end
end

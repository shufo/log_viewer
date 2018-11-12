defmodule LogViewer.V1WebSocketHandler do
  @behaviour :cowboy_websocket_handler

  def init(_, req, _opts) do
    opts = %{idle_timeout: 60000}

    {:upgrade, :protocol, :cowboy_websocket, req, opts}
  end

  def websocket_init(_transport, req, state) do
    Registry.register(:client_registry, :clients, [])
    {:ok, req, %{state: state, proxy: nil}, 60_000}
  end

  def websocket_terminate(_reason, _req, _state) do
    :ok
  end

  def websocket_handle({:text, message}, req, state) do
    {:reply, {:text, message}, req, state}
  end

  def websocket_handle(_data, req, state) do
    {:ok, req, state}
  end

  def websocket_info({:timeout, _ref, message}, req, state) do
    {:reply, {:text, message}, req, state}
  end

  def websocket_info({:broadcast, message}, req, state) do
    {:reply, {:text, message}, req, state}
  end
end

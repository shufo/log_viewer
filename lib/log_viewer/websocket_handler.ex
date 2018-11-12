defmodule LogViewer.WebSocketHandler do
  def init(req, state) do
    opts = %{idle_timeout: 60000}

    {:cowboy_websocket, req, state, opts}
  end

  def websocket_init(state) do
    Registry.register(:client_registry, :clients, [])
    {:ok, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end

  def websocket_handle({:text, message}, state) do
    {:reply, {:text, message}, state}
  end

  def websocket_handle(_data, state) do
    {:ok, state}
  end

  def websocket_info({:timeout, _ref, message}, state) do
    {:reply, {:text, message}, state}
  end

  def websocket_info({:broadcast, message}, state) do
    {:reply, {:text, message}, state}
  end
end

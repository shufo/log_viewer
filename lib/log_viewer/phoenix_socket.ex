defmodule LogViewer.PhoenixSocket do
  use GenServer

  def init(args) do
    {:ok, args}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def __transports__ do
    handler = cowboy_version_adapter()

    config = [
      cowboy: handler
    ]

    callback_module = LogViewer.PhoenixSocket
    transport_path = :websocket
    websocket_socket = {transport_path, {callback_module, config}}

    [websocket_socket]
  end

  defp cowboy_version_adapter() do
    case Application.spec(:cowboy, :vsn) do
      [?1 | _] -> LogViewer.V1WebSocketHandler
      _ -> LogViewer.WebSocketHandler
    end
  end
end

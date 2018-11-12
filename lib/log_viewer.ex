defmodule LogViewer do
  use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    standalone? = Application.get_env(:log_viewer, :standalone, true)

    children =
      if standalone? do
        [
          worker(LogViewer.Server, [[port: Application.get_env(:log_viewer, :port, 5900)]]),
          supervisor(Registry, [[keys: :duplicate, name: :client_registry]])
        ]
      else
        [
          supervisor(Registry, [[keys: :duplicate, name: :client_registry]])
        ]
      end

    opts = [strategy: :one_for_one, name: LogViewer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def info(term) do
    term |> inspect(pretty: true) |> Logger.info()
  end

  def debug(term) do
    term |> inspect(pretty: true) |> Logger.debug()
  end

  def warn(term) do
    term |> inspect(pretty: true) |> Logger.warn()
  end

  def error(term) do
    term |> inspect(pretty: true) |> Logger.error()
  end
end

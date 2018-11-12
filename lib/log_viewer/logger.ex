defmodule LogViewer.Logger do
  @moduledoc false

  @behaviour :gen_event
  require Logger

  defstruct colors: nil,
            format: nil,
            level: nil,
            metadata: nil

  def init(:log_viewer) do
    config = Application.get_env(:logger, :log_viewer)

    {:ok, init(config, %__MODULE__{})}
  end

  def init({__MODULE__, opts}) when is_list(opts) do
    config = configure_merge(Application.get_env(:logger, :log_viewer, []), opts)

    {:ok, init(config, %__MODULE__{})}
  end

  def handle_call({:configure, options}, state) do
    {:ok, :ok, configure(options, state)}
  end

  def handle_event({_level, gl, _event}, state) when node(gl) != node() do
    {:ok, state}
  end

  def handle_event({level, _gl, {Logger, msg, ts, md}}, state) do
    %{level: log_level} = state

    cond do
      not meet_level?(level, log_level) ->
        {:ok, state}

      true ->
        {:ok, log_event(level, msg, ts, md, state)}
    end
  end

  def handle_event(:flush, state) do
    {:ok, state}
  end

  def handle_event(_, state) do
    {:ok, state}
  end

  def handle_info(_, state) do
    {:ok, state}
  end

  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end

  def terminate(_reason, _state) do
    :ok
  end

  ## Helpers

  defp meet_level?(_lvl, nil), do: true

  defp meet_level?(lvl, min) do
    Logger.compare_levels(lvl, min) != :lt
  end

  defp configure(options, state) do
    config = configure_merge(Application.get_env(:logger, :log_viewer), options)
    Application.put_env(:logger, :log_viewer, config)
    init(config, state)
  end

  defp init(config, state) do
    level = Keyword.get(config, :level)
    format = Logger.Formatter.compile(Keyword.get(config, :format))
    colors = configure_colors(config)
    metadata = Keyword.get(config, :metadata, []) |> configure_metadata()

    %{
      state
      | format: format,
        metadata: metadata,
        level: level,
        colors: colors
    }
  end

  defp configure_metadata(:all), do: :all
  defp configure_metadata(metadata), do: Enum.reverse(metadata)

  defp configure_merge(env, options) do
    Keyword.merge(env, options, fn
      :colors, v1, v2 -> Keyword.merge(v1, v2)
      _, _v1, v2 -> v2
    end)
  end

  defp configure_colors(config) do
    colors = Keyword.get(config, :colors, [])

    %{
      debug: Keyword.get(colors, :debug, :cyan),
      info: Keyword.get(colors, :info, :normal),
      warn: Keyword.get(colors, :warn, :yellow),
      error: Keyword.get(colors, :error, :red),
      enabled: Keyword.get(colors, :enabled, IO.ANSI.enabled?())
    }
  end

  # seng log event
  defp log_event(level, msg, ts, md, state) do
    {{year, month, day}, {hour, minute, second, millisecond}} = ts

    metadata =
      md
      |> Enum.map(fn {k, v} -> {k, inspect(v)} end)
      |> Enum.into(%{})
      |> Map.put(:level, level)

    message =
      %{
        id: :crypto.strong_rand_bytes(32) |> Base.encode64() |> binary_part(0, 32),
        msg: msg |> to_string,
        ts: %{
          year: year,
          month: month,
          day: day,
          hour: hour,
          minute: minute,
          second: second,
          millisecond: millisecond
        },
        md: metadata
      }
      |> Jason.encode!()

    # broadcast to all clients
    if Process.whereis(:client_registry) |> is_pid do
      dispatch(message)
    end

    state
  end

  defp dispatch(message) do
    Registry.dispatch(:client_registry, :clients, fn entries ->
      for {pid, _} <- entries do
        send(pid, {:broadcast, message})
      end
    end)
  end
end

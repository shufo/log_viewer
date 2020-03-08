![Tests](https://github.com/shufo/log_viewer/workflows/Tests/badge.svg)
[![Dependabot Status](https://api.dependabot.com/badges/status?host=github&repo=shufo/log_viewer)](https://dependabot.com)

# LogViewer

An Web based Log Viewer for Elixir and Phoenix

## Overview

<a href="https://i.imgur.com/WPAhlCS.png"><img src="https://i.imgur.com/WPAhlCS.png" width="800"></a>

### Features

- :mag: Filtering logs with level and search word
- :fast_forward: Realtime Update
- :rainbow: Syntax Highlighted logs
- Phoenix 1.3 & 1.4 supported

![Imgur](https://i.imgur.com/0qj93i4.gif)

## Installation

`mix.exs`

```elixir
def deps do
  [
    {:log_viewer, "~> 0.1.0", only: [:dev]}
  ]
end
```

Log Viewer is mainly focused on development purpose. So in production environment, please consider to using Log Management platform like AWS CloudWatch Logs, Papertrail and timber.

## Configuration

Add `{LogViewer.Logger, []}` to your logger backends

```elixir
config :logger,
  backends: [{LogViewer.Logger, []}, :console]
```

then start your application and open http://localhost:5900

```bash
$ ➜ iex -S mix
Erlang/OTP 21 [erts-10.1] [source] [64-bit] [smp:16:16] [ds:16:16:10] [async-threads:1] [hipe]

05:51:25.379 [info]  Log Viewer started listening on http://localhost:5900
Interactive Elixir (1.7.4) - press Ctrl+C to exit (type h() ENTER for help)
```

then output logs by Logger

```elixir
iex> require Logger
iex> Logger.info("foo")
iex> Logger.debug("foo")
iex> Logger.warn("foo")
iex> Logger.error("foo")
```

![Imgur](https://i.imgur.com/4wNB2TZ.png)

## Usage

### Phoenix Integration

Basically Log Viewer can works as standalone elixir app.

But you can also integrate Log Viewer with Phoenix as well.

1. Add route for Log Viewer

`router.ex`

```elixir
scope "/" do
  pipe_through(:browser)
  get("/", MyAppWeb.PageController, :index)
end

# Route for Log Viewer
forward("/log_viewer", LogViewer.Router)
```

### Cowboy

:exclamation: Phoenix depends [Cowboy](https://github.com/ninenines/cowboy) HTTP server and Cowboy 2.0 had breaking change, so you must change configuration according to Phoenix and Cowboy version.

#### For Phoenix 1.3 users

`endpoint.ex`

```elixir
socket("/log_viewer", LogViewer.PhoenixSocket)
```

:exclamation:️ This path **MUST** same with the path you defined in router.

#### For Phoenix 1.4 & Cowboy 1.0 users

This case is for if you have upgraded Phoenix 1.3 to 1.4 and still using cowboy 1.0

`endpoint.ex`

```elixir
socket "/log_viewer", LogViewer.PhoenixSocket,
    websocket: true,
    longpoll: false
```

#### For Phoenix 1.4 & Cowboy 2.0 users

`config/config.exs`

Please **CHANGE** app name to your app name. (`:my_app`, `MyAppWeb`)

```elixir
config :my_app, MyAppWeb.Endpoint,
  http: [
    dispatch: [
      {:_,
       [
         {"/log_viewer/websocket", LogViewer.WebSocketHandler, []},
         {:_, Phoenix.Endpoint.Cowboy2Handler, {MyAppWeb.Endpoint, []}}
       ]}
    ]
  ]
```

then start the phoenix and open http://localhost:4000/log_viewer in browser to view Log Viewer

![Imgur](https://i.imgur.com/QSHd8Dx.png)

### Standalone mode

If you are using phoenix integration and standalone server is not necessary, you can disable standalone server. Defaults to `true`.

`config/config.exs`

```elixir
config :log_viewer, standalone: false
```

### Standalone server port

If you want to change standalone server port. Defaults to `5900`.

`config/config.exs`

```elixir
config :log_viewer, port: 4002
```

### Log Level

You can set log level. Defaults to `:all`.

This config results to only info level log

`config/config.exs`

```elixir
config :log_viewer, level: :info
```

## Tips

Use `inspect/2` with `pretty: true` option will outputs pretty-printed logs

```elixir
self() |> Process.info() |> inspect(pretty: true) |> Logger.info()
```

![Imgur](https://i.imgur.com/yls6AC0.png)

## Contributing

1.  Fork it
2.  Create your feature branch (`git checkout -b my-new-feature`)
3.  Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5.  Create new Pull Request

## Test

1. Clone this repo
2. `mix deps.get && iex -S mix`
3. Open another window to run nuxt.js
4. `cd src && npm install && npm run dev`

## TODO

- [ ] Log Persistence
- [ ] Configurable Syntax Highlight theme
- [ ] Performance Improvement

## License

MIT

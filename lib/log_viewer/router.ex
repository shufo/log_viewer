defmodule LogViewer.Router do
  use Plug.Router

  @asset_dir "priv"

  plug(Plug.Static, at: "/_nuxt", from: {:log_viewer, @asset_dir <> "/_nuxt"})

  plug(:match)
  plug(:dispatch)

  get "/" do
    if String.ends_with?(conn.request_path, "/") do
      conn
      |> Plug.Conn.put_resp_content_type("text/html")
      |> Plug.Conn.send_resp(200, File.read!(index_file()))
    else
      # redirect to trailing slash path to load relative static files
      conn
      |> Plug.Conn.put_resp_header("location", conn.request_path <> "/")
      |> Plug.Conn.send_resp(302, "You are being redirected")
    end
  end

  defp index_file do
    Path.join(Application.app_dir(:log_viewer), @asset_dir <> "/index.html")
  end
end

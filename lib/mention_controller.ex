defmodule Webmention.MentionController do
  import Plug.Conn
  use Plug.Builder
  use Plug.Debugger
  plug Webmention.Plug

  def init(options) do
    options
  end

  def call(conn, function) do
    apply(__MODULE__, function, [conn, conn.params])
  end

  def create(conn, params) do
    content = Webmention.Plug.call(conn, nil)
    conn |> send_resp(200, "Got #{content}")
  end
end

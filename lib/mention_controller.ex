defmodule Webmention.MentionController do
  import Plug.Conn
  use Plug.Builder
  use Plug.Debugger
  require Logger
  plug Webmention.Plug

  def init(options) do
    Logger.debug inspect options
    options
  end

  def call(conn, [function: function, callback: callback, module: module]) do
    Logger.debug inspect function
    apply(__MODULE__, function, [conn, module, callback, conn.params])
  end

  def create(conn, module, callback, params) do
    content = Webmention.Plug.call(conn, nil)
    apply(module, callback, [content])
    conn |> send_resp(200, "Got #{content}")
  end
end

defmodule Webmention.MentionController do
  require Logger
  import Plug.Conn


  def init(options) do
    Application.start(:ibrowse)
    Logger.debug inspect options
    options
  end

  def call(conn, [function: function, callback: callback, module: module]) do
    Logger.debug inspect function
    apply(__MODULE__, function, [conn, module, callback, conn.params])
  end

  def create(conn, module, callback, params) do
    content = Webmention.Plug.call(conn, nil)
    apply(module, callback, [conn, content])
    Logger.debug inspect content
    conn |> send_resp(200, "Got #{content}")
  end

  def token(conn, module, callback, params) do
    # Logger.debug
    access_token = apply(module, callback, [params["code"]])
    conn |> send_resp(200, :jsx.encode(%{access_token: access_token, token_type: "bearer", expires_in: 3600}))
    # conn |> send_resp(200, "TEST")
  end
end

defmodule Webmention.Plug do
  import Plug.Conn

  @moduledoc """
  This plug is for your webmention controller, use it to verify and create webmentions
  """
  require IEx

  def init(options) do
    options
  end

  def call(conn, _options) do
    target_host = URI.parse(conn.params["target"]).host
    if conn.host != target_host do
      conn |> send_resp(400, "This is not the host you're looking for")
    end
    verified = Webmention.verify conn.params["source"], conn.params["target"]
    case verified do
      {:error, _message} ->
        conn |> send_resp(403, "Webmention source not verified.")
      {:ok, html} ->
        content = html |> Webmention.content
        # conn |> put_private :message_content, content
        content
    end
  end
end

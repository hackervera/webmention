defmodule Webmention.Plug do
  import Plug.Conn
  require Logger

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
    token =
      cond do
      conn.params["code"] -> Webmention.get_token(conn.params["source"], conn.params["code"])
      true -> ""
    end
    verified = Webmention.verify(conn.params["source"], token, conn.params["target"])
    case verified do
      {:error, _message} ->
        conn |> send_resp(403, "Webmention source not verified.")
        nil
      {:ok, html} ->
        uri = URI.parse(conn.params["source"])
        url = "#{uri.scheme}://#{uri.host}"
        content = html |> Webmention.content(url)
        Logger.debug inspect content
        # conn |> put_private :message_content, content
        content
    end
  end
end

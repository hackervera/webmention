defmodule Webmention.Authorize do
  import Plug.Conn
  require Logger

  @moduledoc """
  This plug is for your webmention controller, use it to verify and create webmentions
  """

  def init(token) do
    token
  end

  def call(conn, token) do
    auth_header =
      conn.req_headers
      |> Enum.into(%{})
      |> Map.get("authorization")
    auth_header = auth_header || ""
    captures = Regex.named_captures(~r/(?<token>#{token})/, auth_header)
    case captures do
      nil ->
        Logger.debug "No Token"
        conn
        |> put_resp_header("WWW-Authenticate", "Bearer")
        |> put_resp_header("Link", "<http://localhost:4000/indie/token>; rel=\"token_endpoint\"")
        |> send_resp(401, "Token required")
      val ->
        Logger.debug inspect val
        conn
    end
  end
end

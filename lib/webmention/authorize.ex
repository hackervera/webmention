defmodule Webmention.Authorize do
  import Plug.Conn
  require Logger

  @moduledoc """
  This plug is for your webmention controller, use it to verify and create webmentions
  """

  def init(token_func) do
    token_func
  end

  def call(conn, token_func) do
    Logger.debug inspect conn.req_headers
    host = conn.req_headers |> Enum.into(%{}) |> Map.get("host")
    auth_header =
      conn.req_headers
      |> Enum.into(%{})
      |> Map.get("authorization")
    auth_header = auth_header || ""
    Logger.debug inspect auth_header
    captures = Regex.named_captures(~r/Bearer (?<token>.*)/, auth_header) || %{}
    Logger.debug inspect captures
    token = Map.get(captures, "token")
    authorized? = token_func.(conn, token)
    case authorized? do
      false ->
        conn
        |> put_resp_header("WWW-Authenticate", "Bearer")
        |> put_resp_header("Link", "<#{conn.scheme}://#{host}/indie/token>; rel=\"token_endpoint\"")
        |> send_resp(401, "Token required")
      true ->
        conn
    end
  end
end

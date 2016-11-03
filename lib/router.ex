defmodule Webmention.Router do
  alias Webmention.MentionController

  defmacro __using__(options) do
    # %{function: :create, callback: options.webmention_callback}
    # Force app to start so we can use it later
    HTTPotion.start
    quote do
      @indie_options unquote options
      pipeline :indieweb do
        plug :put_webmention_header
      end

      def put_webmention_header(conn, _opts) do
        webmention_endpoint = "<#{__MODULE__.Helpers.url(conn)}/#{@indie_options.root}/webmention>; rel=\"webmention\""
        conn |> Plug.Conn.put_resp_header("Link", webmention_endpoint)
      end

      scope "/#{@indie_options.root}" do
        post "/webmention", MentionController, [function: :create, callback: @indie_options.webmention_callback, module: __MODULE__]
      end
    end
  end
end

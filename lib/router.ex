defmodule Webmention.Router do

  alias Webmention.MentionController
  defmacro __using__(options) do
    opts = %{foo: :bar}
    # %{function: :create, callback: options.webmention_callback}
    # Force app to start so we can use it later
    HTTPotion.start
    quote do
      options = unquote options
      scope "/#{options.root}" do
       post "/webmention", MentionController, [function: :create, callback: options.webmention_callback, module: __MODULE__]
      end
    end
  end
end

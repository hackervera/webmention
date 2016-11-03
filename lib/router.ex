defmodule Webmention.Router do
  defmacro __using__(root) do
    HTTPotion.start
    quote do
      scope "/#{unquote root}" do
        post "/webmention", Webmention.MentionController, :create
      end
    end
  end
end

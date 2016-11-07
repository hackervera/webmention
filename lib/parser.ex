defmodule Webmention.Parser do
  use HTTPotion.Base
  require Logger
  def process_response_body(body) do
    # Logger.debug  body
    body |> IO.iodata_to_binary |> :jsx.decode
    |> Enum.map(fn ({k, v}) -> { String.to_atom(k), v } end)
    |> :orddict.from_list
  end
end

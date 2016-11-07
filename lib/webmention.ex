defmodule Webmention do
  use PatternTap
  @moduledoc """
  This module is for creating webmentions
  """

  require Logger
  require IEx

  @doc """
  Attempt to get token for private content
  """

  def get_token(source, code) do
    # Logger.debug  inspect HTTPotion.head(source).headers
    link = HTTPotion.head(source).headers[:link]
    url =
      case link do
        links when is_list(link) ->
          links
          |> Enum.find_value(%{}, fn link -> Regex.named_captures(~r/<(?<url>.*)>.*token_endpoint.*/, link) end)
        link ->
          Regex.named_captures(~r/<(?<url>.*)>.*token_endpoint.*/, link)
      end
      |> Map.get("url")
    Webmention.Parser.post(url, grant_type: "authorization_code", code: code).body[:access_token]

  end


  @doc """
  Hit source url and see if it points to target anywhere in the body

  Example:
  Webmention.verify "https://css-tricks.com/attribute-selectors/", "/video-screencasts/"
  """
  def verify(source, token, target) do
    # Logger.debug inspect [source, token, target]
    html = HTTPotion.get(source, [headers: [Authorization: "Bearer " <> token]]).body
    a_hrefs = Floki.find(html, "a[href='#{target}']")
    link_hrefs = Floki.find(html, "link[href='#{target}']")
    all_refs = a_hrefs ++ link_hrefs
    result =  all_refs |> List.first
    # Logger.debug inspect result
    if result do
      {:ok, html}
    else
      {:error, "Not verified"}
    end
  end

  def content(html, url) do
    # TODO A method to parse out links
    micro_data = Microformats2.parse(html, url)
    items =
      micro_data.items
      |> Enum.filter(fn(item) ->
      Enum.find(item.type, fn(type) ->
        type in ["h-entry", "h-card"]
      end)
    end)
    Logger.debug inspect items
    # Floki.find(html, "[class*=e-content]") |> List.first |> Floki.raw_html
    items
  end

  def endpoint(content_url) do
    response = HTTPotion.get(content_url)
    {_,[{"href", webmention_url}|_],_} = response.body |> Floki.find("[rel=webmention]") |> List.first
    webmention_url
  end

  @doc """
  Ping remote webmention endpoint to update with new reply
  """
  def ping(content_url, reply_url) do
    IEx.pry

  end

  @doc """
  This will try to find the url somewhere in our system
  """
  def lookup_url(_url) do
  end

  @doc """
  Convert a floki tree to html again
  """
  def tag_parser(tree) do
    {tag, options, children} = tree

    formatted_options = options |> Enum.map(fn option ->
      {key, value} = option
      " #{key}='#{value}'"
    end)

    formatted_kids = children |> Enum.map(fn child ->
      if is_tuple child do
        tag_parser child
      else
        child |> String.replace("\n", "")
      end
    end) |> Enum.join("") |> String.strip

    "<#{tag}#{formatted_options}>#{formatted_kids}</#{tag}>"
  end
end

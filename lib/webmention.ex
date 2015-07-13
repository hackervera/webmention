defmodule Webmention do
  @moduledoc """
  This module is for creating webmentions
  """
  
  require Logger
  require IEx

  @doc """
  Hit source url and see if it points to target anywhere in the body
  
  Example:  
  Webmention.verify "https://css-tricks.com/attribute-selectors/", "/video-screencasts/"
  """
  def verify(source, target) do
    html = HTTPotion.get(source).body
    a_hrefs = Floki.find(html, "a[href=#{target}]")
    link_hrefs = Floki.find(html, "link[href=#{target}]")
    all_refs = a_hrefs ++ link_hrefs
    result =  all_refs |> List.first
    if result do
      {:ok, html}
    else
      {:error, "Not verified"}
    end
  end
  
  def content(html) do
    # TODO A method to parse out links
    Floki.find(html, "[class=e-content]") |> List.first
  end
  
  @doc """
  This will try to find the url somewhere in our system
  """
  def lookup_url(url) do
    
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
        child |> String.replace "\n", "" 
      end
    end) |> Enum.join("") |> String.strip
    
    "<#{tag}#{formatted_options}>#{formatted_kids}</#{tag}>"
  end
  
  
end

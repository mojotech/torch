defmodule Torch.NavigationView do
  @moduledoc """
  Helpers for generating admin navigation links.
  """

  use Phoenix.HTML

  @doc """
  Generates a navigation link, with the "active" class if you are on that page.

  ## Example

      nav_link(conn, "Posts", admin_post_path(conn, :index))
  """
  def nav_link(conn, text, path) do
    class = if conn.request_path =~ path, do: "active", else: ""
    link text, to: path, class: class
  end
end

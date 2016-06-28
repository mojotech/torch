defmodule Torch.NavigationView do
  use Phoenix.HTML

  def nav_link(conn, text, path) do
    class = if conn.request_path =~ path, do: "active", else: ""
    link text, to: path, class: class
  end
end

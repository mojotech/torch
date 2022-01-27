defmodule Phx16Web.PageController do
  use Phx16Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

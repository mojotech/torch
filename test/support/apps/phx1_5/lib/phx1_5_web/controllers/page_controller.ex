defmodule Phx15Web.PageController do
  use Phx15Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

defmodule Phx14Web.PageController do
  use Phx14Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

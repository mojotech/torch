defmodule Phx15SlimeWeb.PageController do
  use Phx15SlimeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

defmodule Phx18Web.PageController do
  use Phx18Web, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

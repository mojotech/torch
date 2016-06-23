defmodule Example.Admin.PostController do
  use Example.Web, :controller

  import Radmin.Query

  alias Example.Post
  alias Filtrex.Type.Config

  plug :put_layout, {Example.LayoutView, "admin.html"}

  @page_size 10
  @config [
    %Config{type: :text, keys: ~w(title body)},
    %Config{type: :date, keys: ~w(inserted_at updated_at), options: %{format: "{YYYY}-{0M}-{0D}"}},
  ]

  def index(conn, params) do
    opts = [
      filtrex: @config,
      params: params["post"],
      page: params["page"],
      page_size: @page_size
    ]

    posts = Repo.all query(Post, opts)
    render conn, "index.html", posts: posts
  end
end

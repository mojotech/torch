defmodule Example.Admin.PostController do
  use Example.Web, :controller

  import Ecto.Query
  import Torch.Controller, only: [sort: 1, paginate: 4]

  alias Example.Post
  alias Filtrex.Type.Config

  plug :put_layout, {Example.LayoutView, "admin.html"}
  plug :scrub_params, "post" when action in [:create, :update]
  plug :assign_categories

  plug :assign_authors

  @filtrex [
    %Config{type: :boolean, keys: ~w(draft)},
    %Config{type: :date, keys: ~w(inserted_at updated_at), options: %{format: "{YYYY}-{0M}-{0D}"}},
    %Config{type: :text, keys: ~w(title body)},
    %Config{type: :number, keys: ~w(author_id)},
    %Config{type: :number, keys: ~w(category_id)}
  ]

  @pagination [page_size: 10]
  @pagination_distance 5

  def index(conn, params) do
    {:ok, filter} = Filtrex.parse_params(@filtrex, params["post"] || %{})

    page =
      Post
      |> Filtrex.query(filter)
      |> order_by(^sort(params))
      |> paginate(Repo, params, @pagination)

    render conn, "index.html",
      posts: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries,
      distance: @pagination_distance
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: admin_post_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post)
    render conn, "edit.html", changeset: changeset, post: post
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: admin_post_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render("edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: admin_post_path(conn, :index))
  end

  defp assign_categories(conn, _opts) do
    categories =
      Example.Category
      |> Repo.all
      |> Enum.map(&({&1.name, &1.id}))
    assign(conn, :categories, categories)
  end

  defp assign_authors(conn, _opts) do
    authors =
      Example.Author
      |> Repo.all
      |> Enum.map(&({&1.name, &1.id}))
    assign(conn, :authors, authors)
  end
end

defmodule Example.Admin.PostController do
  use Example.Web, :controller

  import Ecto.Query

  alias Example.Post
  alias Filtrex.Type.Config

  plug :assign_page
  plug :put_layout, {Example.LayoutView, "admin.html"}
  plug :scrub_params, "post" when action in [:create, :update]

  @page_size 10
  @config [
    %Config{type: :text, keys: ~w(title body)},
    %Config{type: :date, keys: ~w(inserted_at updated_at), options: %{format: "{YYYY}-{0M}-{0D}"}},
  ]

  def index(conn, params) do
    query = query(Post, @config, params)
    count = count(query)
    posts =
      query
      |> paginate(conn.assigns[:page], @page_size)
      |> order_by(^sort(params))
      |> Repo.all

    conn
    |> assign(:posts, posts)
    |> assign(:num_pages, ceil(count / @page_size))
    |> render("index.html")
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
        render(conn, "new.html", changeset: changeset)
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
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: admin_post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: admin_post_path(conn, :index))
  end




  # TODO: Extract the below into a separate module
  defp sort(%{"sort_field" => field, "sort_direction" => direction}) do
    {String.to_atom(direction), String.to_atom(field)}
  end
  defp sort(_other) do
    {:asc, :id}
  end

  defp query(model, config, params) do
    {:ok, filter} = Filtrex.parse_params(config, params["post"] || %{})
    Filtrex.query(Post, filter)
  end

  defp paginate(query, page_num, page_size)
  when is_integer(page_num) do
    offset = (page_num - 1) * page_size
    do_pagination(query, offset, page_size)
  end
  defp paginate(query, _page_num, page_size) do
    do_pagination(query, 0, page_size)
  end
  defp do_pagination(query, offset, limit) do
    query
    |> offset(^offset)
    |> limit(^limit)
  end

  defp count(query) do
    Repo.one(from m in query, select: count(m.id))
  end

  defp ceil(float) do
    float
    |> Float.ceil
    |> round
  end

  defp assign_page(conn, _opts) do
    page = String.to_integer(conn.params["page"] || "1")
    assign(conn, :page, page)
  end
end

defmodule Example.Admin.AuthorController do
  use Example.Web, :controller

  import Ecto.Query
  import Torch.Controller, only: [sort: 1, paginate: 4]

  alias Example.Author
  alias Filtrex.Type.Config

  plug :put_layout, {Example.LayoutView, "admin.html"}
  plug :scrub_params, "author" when action in [:create, :update]
  @filtrex [
    %Config{type: :date, keys: ~w(inserted_at updated_at), options: %{format: "{YYYY}-{0M}-{0D}"}},
    %Config{type: :text, keys: ~w(name email)}
  ]

  @pagination [page_size: 10]
  @pagination_distance 5

  def index(conn, params) do
    {:ok, filter} = Filtrex.parse_params(@filtrex, params["author"] || %{})

    page =
      Author
      |> Filtrex.query(filter)
      |> order_by(^sort(params))
      |> paginate(Repo, params, @pagination)

    render conn, "index.html",
      authors: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries,
      distance: @pagination_distance
  end

  def new(conn, _params) do
    changeset = Author.changeset(%Author{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"author" => author_params}) do
    changeset = Author.changeset(%Author{}, author_params)

    case Repo.insert(changeset) do
      {:ok, _author} ->
        conn
        |> put_flash(:info, "Author created successfully.")
        |> redirect(to: admin_author_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    author = Repo.get!(Author, id)
    changeset = Author.changeset(author)
    render conn, "edit.html", changeset: changeset, author: author
  end

  def update(conn, %{"id" => id, "author" => author_params}) do
    author = Repo.get!(Author, id)
    changeset = Author.changeset(author, author_params)

    case Repo.update(changeset) do
      {:ok, _author} ->
        conn
        |> put_flash(:info, "Author updated successfully.")
        |> redirect(to: admin_author_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render("edit.html", author: author, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    author = Repo.get!(Author, id)
    Repo.delete!(author)

    conn
    |> put_flash(:info, "Author deleted successfully.")
    |> redirect(to: admin_author_path(conn, :index))
  end
end

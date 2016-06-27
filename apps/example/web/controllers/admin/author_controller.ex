defmodule Example.Admin.AuthorController do
  use Example.Web, :controller
  use Torch.Controller

  import Ecto.Query

  alias Example.Author
  alias Filtrex.Type.Config

  plug :put_layout, {Example.LayoutView, "admin.html"}
  plug :scrub_params, "author" when action in [:create, :update]

  @page_size 10

  @config [
    %Config{type: :date, keys: ~w(inserted_at updated_at), options: %{format: "{YYYY}-{0M}-{0D}"}},
    %Config{type: :text, keys: ~w(name email)}
  ]

  def index(conn, params) do
    query = query(Author, @config, params["author"])
    count = count(Repo, query)
    authors =
      query
      |> paginate(conn.assigns[:page], @page_size)
      |> order_by(^sort(params))
      |> Repo.all

    conn
    |> assign(:authors, authors)
    |> assign(:num_pages, ceil(count / @page_size))
    |> render("index.html")
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

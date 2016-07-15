defmodule Example.Admin.CategoryController do
  use Example.Web, :controller
  use Torch.Controller

  import Ecto.Query

  alias Example.Category
  alias Filtrex.Type.Config

  plug :put_layout, {Example.LayoutView, "admin.html"}
  plug :scrub_params, "category" when action in [:create, :update]
  @page_size 10

  @config [
    %Config{type: :text, keys: ~w(name)}
  ]

  def index(conn, params) do
    query = query(Category, @config, params["category"])
    count = count(Repo, query)
    categories =
      query
      |> paginate(conn.assigns[:page], @page_size)
      |> order_by(^sort(params))
      |> Repo.all

    conn
    |> assign(:categories, categories)
    |> assign(:num_pages, ceil(count / @page_size))
    |> render("index.html")
  end

  def new(conn, _params) do
    changeset = Category.changeset(%Category{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"category" => category_params}) do
    changeset = Category.changeset(%Category{}, category_params)

    case Repo.insert(changeset) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: admin_category_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    changeset = Category.changeset(category)
    render conn, "edit.html", changeset: changeset, category: category
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Repo.get!(Category, id)
    changeset = Category.changeset(category, category_params)

    case Repo.update(changeset) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: admin_category_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render("edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    Repo.delete!(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: admin_category_path(conn, :index))
  end
end

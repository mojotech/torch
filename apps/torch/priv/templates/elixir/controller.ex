defmodule <%= module %>Controller do
  use <%= base %>.Web, :controller
  use Torch.Controller

  import Ecto.Query

  alias <%= base %>.<%= alias %>
  alias Filtrex.Type.Config

  plug :put_layout, {<%= base %>.LayoutView, "admin.html"}
  plug :scrub_params, "<%= singular %>" when action in [:create, :update]<%= for plug <- assoc_plugs do %>
  <%= plug %>
<% end %>
  @page_size 10
<%= if length(configs) > 0 do %>
  @config [
    <%= Enum.join(configs, ",\n\s\s\s\s") %>
  ]
<% else %>
  @config []
<% end %>
  def index(conn, params) do
    query = query(<%= alias %>, @config, params["<%= singular %>"])
    count = count(Repo, query)
    <%= plural %> =
      query
      |> paginate(conn.assigns[:page], @page_size)
      |> order_by(^sort(params))
      |> Repo.all

    conn
    |> assign(:<%= plural %>, <%= plural %>)
    |> assign(:num_pages, ceil(count / @page_size))
    |> render("index.html")
  end

  def new(conn, _params) do
    changeset = <%= alias %>.changeset(%<%= alias %>{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"<%= singular %>" => <%= singular %>_params}) do
    changeset = <%= alias %>.changeset(%<%= alias %>{}, <%= singular %>_params)

    case Repo.insert(changeset) do
      {:ok, _<%= singular %>} ->
        conn
        |> put_flash(:info, "<%= human %> created successfully.")
        |> redirect(to: <%= namespace_underscore %>_<%= singular %>_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    <%= singular %> = Repo.get!(<%= alias %>, id)
    changeset = <%= alias %>.changeset(<%= singular %>)
    render conn, "edit.html", changeset: changeset, <%= singular %>: <%= singular %>
  end

  def update(conn, %{"id" => id, "<%= singular %>" => <%= singular %>_params}) do
    <%= singular %> = Repo.get!(<%= alias %>, id)
    changeset = <%= alias %>.changeset(<%= singular %>, <%= singular %>_params)

    case Repo.update(changeset) do
      {:ok, _<%= singular %>} ->
        conn
        |> put_flash(:info, "<%= human %> updated successfully.")
        |> redirect(to: <%= namespace_underscore %>_<%= singular %>_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render("edit.html", <%= singular %>: <%= singular %>, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    <%= singular %> = Repo.get!(<%= alias %>, id)
    Repo.delete!(<%= singular %>)

    conn
    |> put_flash(:info, "<%= human %> deleted successfully.")
    |> redirect(to: <%= namespace_underscore %>_<%= singular %>_path(conn, :index))
  end
<%= if length(assoc_plug_definitions) > 0, do: "\n" <> (assoc_plug_definitions |> Enum.intersperse("\n") |> Enum.join) %>end

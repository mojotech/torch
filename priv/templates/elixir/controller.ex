defmodule <%= module %>Controller do
  use <%= base %>.Web, :controller

  import Ecto.Query
  import Torch.Controller, only: [sort: 1, paginate: 4]

  alias <%= base %>.<%= alias %>
  alias Filtrex.Type.Config

  plug :put_layout, {<%= base %>.LayoutView, "admin.html"}
  plug :scrub_params, "<%= singular %>" when action in [:create, :update]<%= for plug <- assoc_plugs do %>
  <%= plug %>
<% end %><%= if length(configs) > 0 do %>
  @filtrex [
    <%= Enum.join(configs, ",\n\s\s\s\s") %>
  ]
<% else %>
  @filtrex []
<% end %>
  @pagination [page_size: 10]
  @pagination_distance 5

  def index(conn, params) do
    {:ok, filter} = Filtrex.parse_params(@filtrex, params["<%= singular %>"] || %{})

    page =
      <%= alias %>
      |> Filtrex.query(filter)
      |> order_by(^sort(params))
      |> paginate(Repo, params, @pagination)

    render conn, "index.html",
      <%= plural %>: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries,
      distance: @pagination_distance
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

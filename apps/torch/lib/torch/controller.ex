defmodule Torch.Controller do
  import Phoenix.Controller
  import Plug.Conn
  import Ecto.Query

  defmacro __using__(_) do
    quote do
      import Torch.Controller

      plug :assign_page
    end
  end

  def sort(%{"sort_field" => field, "sort_direction" => direction}) do
    {String.to_atom(direction), String.to_atom(field)}
  end
  def sort(_other) do
    {:asc, :id}
  end

  def query(model, config, params) do
    {:ok, filter} = Filtrex.parse_params(config, params || %{})
    Filtrex.query(model, filter)
  end

  def paginate(query, page_num, page_size)
  when is_integer(page_num) do
    offset = (page_num - 1) * page_size
    do_pagination(query, offset, page_size)
  end
  def paginate(query, _page_num, page_size) do
    do_pagination(query, 0, page_size)
  end
  defp do_pagination(query, offset, limit) do
    query
    |> offset(^offset)
    |> limit(^limit)
  end

  def count(repo, query) do
    repo.one(from m in query, select: count(m.id))
  end

  def ceil(float) do
    float
    |> Float.ceil
    |> round
  end

  def assign_page(conn, _opts) do
    page = String.to_integer(conn.params["page"] || "1")
    assign(conn, :page, page)
  end
end

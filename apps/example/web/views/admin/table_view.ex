defmodule Example.Admin.TableView do
  import Phoenix.HTML
  import Phoenix.HTML.Link

  def table_link(conn, text, field) do
    direction = conn.params["sort_direction"]

    if conn.params["sort_field"] == to_string(field) do
      opts = [
        sort_field: field,
        sort_direction: reverse(direction)
      ]

      link to: "?" <> querystring(conn, opts), class: "active #{direction}" do
        raw(~s{#{text}<span class="caret"></span>})
      end
    else
      opts = [
        sort_field: field,
        sort_direction: "desc"
      ]
      link to: "?" <> querystring(conn, opts) do
        raw(~s{#{text}<span class="caret"></span>})
      end
    end
  end

  def querystring(conn, opts) do
    opts = [
      page: opts[:page] || conn.assigns[:page],
      sort_field: opts[:sort_field] || conn.params["sort_field"] || "id",
      sort_direction: opts[:sort_direction] || conn.params["sort_direction"] || "asc"
    ]

    URI.encode_query(opts)
  end

  defp reverse("desc"), do: "asc"
  defp reverse("asc"), do: "desc"
  defp reverse(_), do: "desc"
end

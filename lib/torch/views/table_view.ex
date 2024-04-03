defmodule Torch.TableView do
  @moduledoc """
  Helpers for rendering Torch-generated tables.
  """

  import Phoenix.HTML
  import PhoenixHTMLHelpers.Link

  @doc """
  Generates a sortable link for a table heading.

  Clicking on the link will trigger a sort on that field. Clicking again will
  reverse the sort.

  ## Example

      iex> conn = %Plug.Conn{params: %{"sort_field" => "name", "sort_direction" => "asc"}}
      ...> table_link(conn, "Name", :name) |> safe_to_string()
      "<a class=\\"active asc\\" href=\\"?sort_direction=desc&amp;sort_field=name\\">Name<span class=\\"caret\\"></span></a>"
  """
  @spec table_link(Plug.Conn.t(), String.t(), atom) :: Phoenix.HTML.safe()
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

  @doc """
  Prettifies and associated struct for display.

  Displays the model's name or "None", rather than the struct's ID.

  ## Examples

      iex> table_assoc_display_name(%{category_id: 1}, :category_id, [{"Articles", 1}])
      "Articles"

      iex> table_assoc_display_name(%{category_id: nil}, :category_id, [{"Articles", 1}])
      "None"
  """
  @spec table_assoc_display_name(struct, atom, Keyword.t()) :: String.t()
  def table_assoc_display_name(struct, field, options) do
    case Enum.find(options, fn {_name, id} -> Map.get(struct, field) == id end) do
      {name, _id} -> name
      _other -> "None"
    end
  end

  @doc """
  Takes an existing URI query string and adds or replaces the page, sort_field, direction with an updated
  query string value.

  ## Examples

      iex> querystring("", %{}, %{page: 1})
      "page=1"

      iex> querystring("foo=bar", %{}, %{page: 2})
      "foo=bar&page=2"

      iex> querystring("foo=bar&page=14", %{}, %{page: 3})
      "foo=bar&page=3"

      iex> querystring("foo=bar", %{"sort_direction" => "asc", "sort_field" => "name"}, %{page: 4})
      "foo=bar&page=4&sort_direction=asc&sort_field=name"

      iex> querystring("foo=bar", %{"sort_direction" => "asc", "sort_field" => "name"}, %{page: 4, sort_direction: "desc"})
      "foo=bar&page=4&sort_direction=desc&sort_field=name"

      iex> querystring("foo=bar", %{"sort_direction" => "asc", "sort_field" => "name"}, %{page: 4, sort_direction: "desc", sort_field: "id"})
      "foo=bar&page=4&sort_direction=desc&sort_field=id"
  """
  def querystring(%Plug.Conn{} = conn, opts) do
    querystring(conn.query_string, conn.params, opts)
  end

  @spec querystring(String.t(), %{optional(binary()) => term()}, %{optional(atom()) => term()}) ::
          String.t()
  def querystring(conn_query_string, conn_params, opts) do
    original = URI.decode_query(conn_query_string)

    opts = %{
      "page" => opts[:page],
      "sort_field" => opts[:sort_field] || conn_params["sort_field"] || nil,
      "sort_direction" => opts[:sort_direction] || conn_params["sort_direction"] || nil
    }

    original
    |> Map.merge(opts)
    |> Enum.filter(fn {_, v} -> v != nil end)
    |> Enum.into(%{})
    |> URI.encode_query()
  end

  defp reverse("desc"), do: "asc"
  defp reverse("asc"), do: "desc"
  defp reverse(_), do: "desc"
end

defmodule Torch.TableView do
  @moduledoc """
  Helpers for rendering Torch-generated tables.
  """

  import Phoenix.HTML
  import Phoenix.HTML.Link

  @doc """
  Generates a sortable link for a table heading.

  Clicking on the link will trigger a sort on that field. Clicking again will
  reverse the sort.

  ## Example

      table_link(conn, "Name", :name)
  """
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
  Prettifies and associated model for display.

  Displays the model's name or "None", rather than the model's ID.

  ## Example

      # If post.category_id was 1
      table_assoc_display_name(post, :category_id, [{"Articles", 1}])
      # => "Articles"

      # If post.category_id was nil
      table_assoc_display_name(post, :category_id, [{"Articles", 1}])
      # => "None"
  """
  def table_assoc_display_name(model, field, options) do
    case Enum.find(options, fn {_name, id} -> Map.get(model, field) == id end) do
      {name, _id} -> name
      _other -> "None"
    end
  end

  @doc false
  def querystring(conn, opts) do
    original = URI.decode_query(conn.query_string)

    opts = %{
      "page" => opts[:page],
      "sort_field" => opts[:sort_field] || conn.params["sort_field"] || nil,
      "sort_direction" => opts[:sort_direction] || conn.params["sort_direction"] || nil
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
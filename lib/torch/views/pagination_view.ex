defmodule Torch.PaginationView do
  @moduledoc """
  `Phoenix.View` to render pagination controls for Torch-generated index templates.
  """

  use Phoenix.View, root: "lib/torch/templates"
  use Phoenix.HTML

  import Torch.TableView

  @doc """
  Generates a "< Prev" link to the previous page of results.
  The link is only returned if there is a previous page.

  ## Example

      prev_link(2, 2)
      # => returns link

      prev_link(1, 1)
      # => returns nil
  """
  def prev_link(conn, current_page, _num_pages, sort_opts \\ nil) do
    if current_page != 1 do
      link("< Prev", to: "?" <> querystring(conn, page: current_page - 1, sort_opts: sort_opts))
    end
  end

  @doc """
  Generates a "Next >" link to the next page of results.
  The link is only returned if there is another page.

  ## Example
      next_link(1, 2)
      # => returns link

      next_link(2, 2)
      # => returns nil
  """
  def next_link(conn, current_page, num_pages, sort_opts \\ nil) do
    if current_page != num_pages do
      link("Next >", to: "?" <> querystring(conn, page: current_page + 1, sort_opts: sort_opts))
    end
  end

  defp start_page(current_page, distance) when current_page - distance < 1 do
    current_page - (distance + (current_page - distance - 1))
  end

  defp start_page(current_page, distance) do
    current_page - distance
  end

  defp end_page(current_page, 0, _distance) do
    current_page
  end

  defp end_page(current_page, total, distance)
       when current_page <= distance and distance * 2 <= total do
    distance * 2
  end

  defp end_page(current_page, total, distance) when current_page + distance >= total do
    total
  end

  defp end_page(current_page, _total, distance) do
    current_page + distance - 1
  end

  defp sort_opts(%{sort_field: sort_field, sort_direction: sort_direction}) do
    %{sort_field: sort_field, sort_direction: sort_direction}
  end
end
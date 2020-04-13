defmodule Torch.PaginationView do
  @moduledoc """
  `Phoenix.View` to render pagination controls for Torch-generated index templates.
  """

  use Phoenix.View, root: "lib/torch/templates"
  use Phoenix.HTML

  import Torch.I18n, only: [message: 1]
  import Torch.TableView

  @doc """
  Generates a "< Prev" link to the previous page of results.
  The link is only returned if there is a previous page.

  ## Examples

      iex> prev_link(%Plug.Conn{params: %{}}, 2) |> safe_to_string()
      "<a href=\\"?page=1\\">&lt; Prev</a>"

  If the current page is 1, returns `nil`:

      iex> prev_link(%Plug.Conn{params: %{}}, 1)
      nil

  """
  def prev_link(conn, current_page, sort_opts \\ nil) do
    if current_page != 1 do
      link(message("< Prev"),
        to: "?" <> querystring(conn, page: current_page - 1, sort_opts: sort_opts)
      )
    end
  end

  @doc """
  Generates a "Next >" link to the next page of results.
  The link is only returned if there is another page.

  ## Examples

      iex> next_link(%Plug.Conn{params: %{}}, 1, 2) |> safe_to_string()
      "<a href=\\"?page=2\\">Next &gt;</a>"

      iex> next_link(%Plug.Conn{}, 2, 2)
      nil
  """
  def next_link(conn, current_page, num_pages, sort_opts \\ nil) do
    if current_page != num_pages do
      link(message("Next >"),
        to: "?" <> querystring(conn, page: current_page + 1, sort_opts: sort_opts)
      )
    end
  end

  defp start_page(current_page, distance)
       when current_page - distance <= 0 do
    1
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

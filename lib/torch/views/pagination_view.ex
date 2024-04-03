defmodule Torch.PaginationView do
  use Phoenix.Component
  use PhoenixHTMLHelpers

  import Torch.I18n, only: [message: 1]
  alias Torch.TableView

  @doc """
  Render pagination links directly from a `Plug.Conn`
  """
  def pagination(conn) do
    assigns =
      %{__changed__: %{}}
      |> Map.merge(conn.assigns)
      |> assign(:query_string, conn.query_string)
      |> assign(:sort_opts, sort_opts(conn.assigns))
      |> assign(:conn_params, conn.params)

    ~H"""
    <.torch_pagination page_number={@page_number} page_size={@page_size} total_pages={@total_pages} total_entries={@total_entries} distance={@distance} sort_field={@sort_field} sort_direction={@sort_direction} query_string={@query_string} conn_params={@conn_params} />
    """
  end

  @doc """
  Render Torch pagination links based on current page, sort, and filters
  """
  @doc since: "5.0.0"

  attr(:page_number, :integer, required: true)
  attr(:page_size, :integer, required: true)
  attr(:total_pages, :integer, required: true)
  attr(:total_entries, :integer, required: true)
  attr(:distance, :integer, required: false)
  attr(:sort_field, :string, required: false)
  attr(:sort_direction, :string, required: false)
  attr(:query_string, :string, required: true)
  attr(:conn_params, :map, required: true)

  def torch_pagination(assigns) do
    assigns =
      assigns
      |> assign_new(:distance, fn -> 5 end)
      |> assign(
        :new_querystring,
        fn p ->
          TableView.querystring(assigns.query_string, assigns.conn_params, %{
            page: p
          })
        end
      )

    ~H"""
    <section id="torch-pagination">
      <ul>
        <li><.prev_link page_number={@page_number} query_string={@query_string} conn_params={@conn_params} /></li>
        <%= if @total_pages > 1 do %>
          <%= for num <- start_page(@page_number, @distance)..end_page(@page_number, @total_pages, @distance) do %>
            <li>
              <.page_link page_number={num} is_active={@page_number == num} query_string={@query_string} conn_params={@conn_params} />
            </li>
          <% end %>
        <% end %>
        <li><.next_link page_number={@page_number} total_pages={@total_pages} query_string={@query_string} conn_params={@conn_params} /></li>
      </ul>
    </section>
    """
  end

  @doc """
  Generates a "_N_" link to a page of results (where N is the page number).

  ## Examples

      iex> a = %{__changed__: %{}, query_string: "", conn_params: %{page: 1}, page_number: 14}
      ...> page_link(a) |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary()
      "<a href=\\"?page=14\\" class=\\"\\">14</a>"

  It will also allow customizing of the "active" link:

      iex> a = %{__changed__: %{}, query_string: "", conn_params: %{page: 1}, page_number: 14, is_active: true}
      ...> page_link(a) |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary()
      "<a href=\\"?page=14\\" class=\\"active\\">14</a>"
  """
  @doc since: "5.0.0"

  attr(:query_string, :string, default: "")
  attr(:conn_params, :any, required: true)
  attr(:page_number, :integer, required: true)
  attr(:is_active, :boolean, default: false)

  def page_link(
        %{
          __changed__: _,
          query_string: qs,
          conn_params: params,
          page_number: pn
        } = assigns
      )
      when is_integer(pn) and pn > 0 do
    assigns =
      assigns
      |> assign(
        :new_querystring,
        TableView.querystring(qs, params, %{page: pn})
      )

    ~H"""
    <a href={"?#{@new_querystring}"} class={if @is_active, do: "active", else: ""}><%= @page_number %></a>
    """
  end

  def page_link(assigns) do
    ~H"""
    """
  end

  @doc """
  Generates a "< Prev" link to the previous page of results.
  The link is only returned if there is a previous page.

  ## Examples

      iex> a = %{__changed__: nil, query_string: "", conn_params: %{page: 3}, page_number: 3}
      ...> prev_link(a) |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary()
      "<a href=\\"?page=2\\">&lt; Prev</a>"

  If the current page is 1, returns an empty string:

      iex> a = %{__changed__: nil, query_string: "", conn_params: %{page: 1}, page_number: 1}
      ...> prev_link(a) |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary()
      ""
  """
  # NOTE: query_string param can contain sort info also (e.g. sort_field=name&sort_direction=asc)
  @doc since: "5.0.0"

  attr(:query_string, :string, default: "")
  attr(:conn_params, :any, required: true)
  attr(:page_number, :integer, required: true)

  def prev_link(
        %{__changed__: _, query_string: qs, conn_params: params, page_number: pn} = assigns
      )
      when is_integer(pn) and pn > 1 do
    assigns =
      assign(
        assigns,
        :new_querystring,
        TableView.querystring(qs, params, %{page: pn - 1})
      )

    ~H"""
    <a href={"?#{@new_querystring}"}><%= message("< Prev") %></a>
    """
  end

  def prev_link(%{__changed__: _, query_string: _, conn_params: _, page_number: _} = assigns) do
    ~H"""
    """
  end

  def prev_link(%{__changed__: _changed, query_string: _qs, page_number: _pn} = assigns) do
    assigns
    |> assign(:conn_params, %{})
    |> prev_link()
  end

  def prev_link(%{__changed__: _changed, query_string: _qs, conn_params: _p} = assigns) do
    assigns
    |> assign(:page_number, 1)
    |> prev_link()
  end

  def prev_link(%{__changed__: _changed, query_string: _qs} = assigns) do
    assigns
    |> assign(:page_number, 1)
    |> assign(:conn_params, %{})
    |> prev_link()
  end

  @doc """
  Generates a "Next >" link to the next page of results.
  The link is only returned if there is another page.

  ## Examples

      iex> a = %{__changed__: nil, query_string: "", conn_params: %{page: 2}, page_number: 2, total_pages: 4}
      ...> next_link(a) |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary()
      "<a href=\\"?page=3\\">Next &gt;</a>"

  If there is no available next page, returns an empty string:

      iex> a = %{__changed__: nil, query_string: "", conn_params: %{page: 2}, page_number: 2, total_pages: 2}
      ...> next_link(a) |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary()
      ""
  """
  @doc since: "5.0.0"

  attr(:query_string, :string, default: "")
  attr(:conn_params, :any, required: true)
  attr(:page_number, :integer, required: true)
  attr(:total_pages, :integer, required: true)

  def next_link(
        %{
          __changed__: _,
          query_string: qs,
          conn_params: params,
          page_number: page_number,
          total_pages: total_pages
        } = assigns
      )
      when is_integer(page_number) and is_integer(total_pages) and page_number < total_pages do
    assigns =
      assign(
        assigns,
        :new_querystring,
        TableView.querystring(qs, params, %{page: page_number + 1})
      )

    ~H"""
    <a href={"?#{@new_querystring}"}><%= message("Next >") %></a>
    """
  end

  def next_link(
        %{
          __changed__: _,
          query_string: _qs,
          conn_params: _params,
          page_number: _page_number,
          total_pages: _total_pages
        } = assigns
      ) do
    ~H"""
    """
  end

  def next_link(
        %{
          __changed__: _,
          query_string: _,
          page_number: _,
          total_pages: _
        } = assigns
      ) do
    assigns
    |> assign(:conn_params, %{})
    |> next_link()
  end

  def next_link(
        %{
          __changed__: _,
          query_string: _,
          conn_params: _,
          total_pages: _
        } = assigns
      ) do
    assigns
    |> assign(:page_number, 1)
    |> next_link()
  end

  def next_link(
        %{
          __changed__: _,
          query_string: _,
          conn_params: _,
          page_number: pn
        } = assigns
      ) do
    assigns
    |> assign(:total_pages, pn)
    |> next_link()
  end

  def next_link(
        %{
          __changed__: _,
          query_string: _
        } = assigns
      ) do
    assigns
    |> assign(:conn_params, %{})
    |> assign(:page_number, 1)
    |> assign(:total_pages, 1)
    |> next_link()
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

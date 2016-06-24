defmodule Example.Admin.PaginationView do
  use Example.Web, :view

  import Example.Admin.TableView

  def prev_link(current_page, num_pages) do
    if current_page == 1 do
      link "< Prev", to: "#"
    else
      link "< Prev", to: "?page=#{current_page - 1}"
    end
  end

  def next_link(current_page, num_pages) do
    if current_page == num_pages do
      link "Next >", to: "#"
    else
      link "Next >", to: "?page=#{current_page + 1}"
    end
  end
end

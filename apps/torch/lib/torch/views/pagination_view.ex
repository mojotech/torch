defmodule Torch.PaginationView do
  use Phoenix.View, root: "lib/torch/templates"
  use Phoenix.HTML

  import Torch.TableView

  def prev_link(current_page, _num_pages) do
    if current_page != 1 do
      link "< Prev", to: "?page=#{current_page - 1}"
    end
  end

  def next_link(current_page, num_pages) do
    if current_page != num_pages do
      link "Next >", to: "?page=#{current_page + 1}"
    end
  end
end

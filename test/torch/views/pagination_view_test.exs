defmodule Torch.PaginationViewTest do
  use ExUnit.Case

  import Phoenix.HTML, only: [safe_to_string: 1]

  doctest Torch.PaginationView, import: true
end

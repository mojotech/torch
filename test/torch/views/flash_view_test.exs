defmodule Torch.FlashViewTest do
  use ExUnit.Case

  import Phoenix.HTML, only: [safe_to_string: 1]

  doctest Torch.FlashView, import: true
end

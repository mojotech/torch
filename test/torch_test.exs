defmodule TorchTest do
  use ExUnit.Case
  doctest Torch

  test "greets the world" do
    assert Torch.hello() == :world
  end
end

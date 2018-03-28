defmodule Torch.FilterViewTest do
  @moduledoc false
  use ExUnit.Case

  alias Torch.FilterView

  describe "filter_date_input" do
    test "renders succesfully" do
      assert {:safe, _} = FilterView.filter_date_input(:post, :inserted_at, %{})
    end
  end
end

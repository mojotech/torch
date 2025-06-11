defmodule Torch.FlopAdapterTest do
  use ExUnit.Case

  alias Torch.FlopAdapter

  describe "to_scrivener_page/2" do
    test "converts Flop.Meta to Scrivener.Page-compatible map" do
      entries = [%{id: 1, name: "Test"}]
      meta = %Flop.Meta{
        current_page: 2,
        page_size: 10,
        total_pages: 5,
        total_count: 42
      }

      result = FlopAdapter.to_scrivener_page(entries, meta)

      assert result.entries == entries
      assert result.page_number == 2
      assert result.page_size == 10
      assert result.total_pages == 5
      assert result.total_entries == 42
    end

    test "handles nil current_page" do
      entries = [%{id: 1, name: "Test"}]
      meta = %Flop.Meta{
        current_page: nil,
        page_size: 10,
        total_pages: 5,
        total_count: 42
      }

      result = FlopAdapter.to_scrivener_page(entries, meta)

      assert result.page_number == 1
    end
  end

  describe "normalize_options/1" do
    test "passes through Flop struct" do
      flop = %Flop{page: 2, page_size: 20}
      assert FlopAdapter.normalize_options(flop) == flop
    end

    test "converts map with page and page_size" do
      opts = %{page: 3, page_size: 15}
      result = FlopAdapter.normalize_options(opts)

      assert result.page == 3
      assert result.page_size == 15
    end

    test "converts Scrivener.Config" do
      config = %Scrivener.Config{page_number: 4, page_size: 25}
      result = FlopAdapter.normalize_options(config)

      assert result.page == 4
      assert result.page_size == 25
    end

    test "converts keyword list" do
      opts = [page: 5, page_size: 30]
      result = FlopAdapter.normalize_options(opts)

      assert result.page == 5
      assert result.page_size == 30
    end

    test "provides defaults for unknown input" do
      result = FlopAdapter.normalize_options(nil)

      assert result.page == 1
      assert result.page_size == 10
    end
  end

  describe "convert_sort/2" do
    test "converts sort parameters to Flop format" do
      {order_by, order_directions} = FlopAdapter.convert_sort(:desc, :name)

      assert order_by == [:name]
      assert order_directions == [:desc]
    end
  end
end

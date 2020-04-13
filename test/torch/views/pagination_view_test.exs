defmodule Torch.PaginationViewTest do
  @moduledoc false
  use ExUnit.Case

  import Phoenix.HTML, only: [safe_to_string: 1]
  import Torch.PaginationView

  doctest Torch.PaginationView, import: true

  describe "prev_link/4" do
    test "when current page is 1" do
      refute prev_link(%Plug.Conn{params: %{}}, 1)
    end

    test "when current page is more than 1" do
      current_page = 2
      link = %Plug.Conn{params: %{}} |> prev_link(current_page) |> safe_to_string()
      assert link =~ "?page=#{current_page - 1}"
    end

    test "internationalization" do
      assert %Plug.Conn{params: %{}} |> prev_link(2) |> safe_to_string() =~ "&lt; Prev"

      set_locale("ru")
      assert %Plug.Conn{params: %{}} |> prev_link(2) |> safe_to_string() =~ "Предыдущая"

      set_locale("es")
      assert %Plug.Conn{params: %{}} |> prev_link(2) |> safe_to_string() =~ "&lt; Prev"
    end
  end

  describe "next_link/4" do
    test "when current page is equal to num pages" do
      refute next_link(%Plug.Conn{}, 2, 2)
    end

    test "when current page is more than num pages" do
      current_page = 1
      link = %Plug.Conn{params: %{}} |> next_link(current_page, 2) |> safe_to_string()
      assert link =~ "?page=#{current_page + 1}"
    end

    test "internationalization" do
      assert %Plug.Conn{params: %{}} |> next_link(1, 2) |> safe_to_string() =~ "Next &gt;"

      set_locale("ru")
      assert %Plug.Conn{params: %{}} |> next_link(1, 2) |> safe_to_string() =~ "Следующая"

      set_locale("es")
      assert %Plug.Conn{params: %{}} |> next_link(1, 2) |> safe_to_string() =~ "Sig &gt;"
    end
  end

  defp set_locale(locale) when is_bitstring(locale) do
    Gettext.put_locale(Torch.Gettext, locale)
  end
end

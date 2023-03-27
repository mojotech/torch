defmodule Torch.PaginationViewTest do
  @moduledoc false
  use ExUnit.Case

  import Phoenix.Component, only: :macros
  import Phoenix.LiveViewTest
  import Torch.PaginationView

  doctest Torch.PaginationView, import: true

  describe "prev_link component" do
    test "when current page is 1" do
      assigns = %{params: %{}, query_string: ""}

      c =
        rendered_to_string(~H"""
        <.prev_link page_number={1} query_string={@query_string} conn_params={@params} />
        """)

      assert "" == c
    end

    test "when current page is greater than 1" do
      assigns = %{current_page: 14, query_string: "", params: %{}}

      c =
        rendered_to_string(~H"""
        <.prev_link page_number={@current_page} query_string={@query_string} conn_params={@params} />
        """)

      assert c =~ "?page=#{assigns.current_page - 1}"
    end

    test "when current page is less than 1" do
      assigns = %{current_page: 0, query_string: "", params: %{}}

      c =
        rendered_to_string(~H"""
        <.prev_link page_number={0} query_string={@query_string} conn_params={@params} />
        """)

      assert "" == c

      c =
        rendered_to_string(~H"""
        <.prev_link page_number={-1} query_string={@query_string} conn_params={@params} />
        """)

      assert "" == c
    end

    test "retains existing query string" do
      assigns = %{current_page: 2, query_string: "foo=bar&page=1", params: %{}}

      c =
        rendered_to_string(~H"""
        <.prev_link page_number={@current_page} query_string={@query_string} conn_params={@params} />
        """)

      assert c =~ "?foo=bar&amp;page=1"
    end

    test "retains existing sort info" do
      assigns = %{
        current_page: 2,
        query_string: "foo=bar&page=2&sort_field=name&sort_direction=desc",
        params: %{"foo" => "bar", "page" => 2, "sort_field" => "name", "sort_direction" => "desc"}
      }

      c =
        rendered_to_string(~H"""
        <.prev_link page_number={@current_page} query_string={@query_string} conn_params={@params} />
        """)

      assert c =~ "?foo=bar&amp;page=1&amp;sort_direction=desc&amp;sort_field=name"
    end

    test "can override original query string via params map" do
      assigns = %{
        current_page: 3,
        query_string: "foo=bar&page=3&sort_field=name&sort_direction=desc",
        params: %{"foo" => "bar", "page" => 3, "sort_field" => "id", "sort_direction" => "asc"}
      }

      c =
        rendered_to_string(~H"""
        <.prev_link page_number={@current_page} query_string={@query_string} conn_params={@params} />
        """)

      assert c =~ "?foo=bar&amp;page=2&amp;sort_direction=asc&amp;sort_field=id"
    end

    test "called without query_string attribute" do
      assigns = %{}

      c =
        rendered_to_string(~H"""
        <.prev_link page_number={3} />
        """)

      assert "<a href=\"?page=2\">&lt; Prev</a>" == c
    end

    test "internationalization" do
      assigns = %{}

      c =
        rendered_to_string(~H"""
        <.prev_link page_number={2} query_string="" />
        """)

      assert c =~ "&lt; Prev"

      set_locale("ru")

      c =
        rendered_to_string(~H"""
        <.prev_link page_number={2} query_string="" />
        """)

      assert c =~ "Предыдущая"

      set_locale("de")

      c =
        rendered_to_string(~H"""
        <.prev_link page_number={2} query_string="" />
        """)

      assert c =~ "&lt; Zurück"
    end
  end

  describe "next_link/4" do
    test "when current page is equal to total pages" do
      assigns = %{params: %{}, query_string: ""}

      c =
        rendered_to_string(~H"""
        <.next_link page_number={1} total_pages={1} query_string={@query_string} conn_params={@params} />
        """)

      assert "" == c
    end

    test "when current page is greater than total pages" do
      assigns = %{params: %{}, query_string: ""}

      c =
        rendered_to_string(~H"""
        <.next_link page_number={3} total_pages={2} query_string={@query_string} conn_params={@params} />
        """)

      assert "" == c
    end

    test "when current page is less than total pages" do
      assigns = %{params: %{}, query_string: "", page_number: 1, total_pages: 8}

      c =
        rendered_to_string(~H"""
        <.next_link page_number={@page_number} total_pages={@total_pages} query_string={@query_string} conn_params={@params} />
        """)

      assert c =~ "?page=#{assigns.page_number + 1}"
    end

    test "called without query_string attribute" do
      assigns = %{}

      c =
        rendered_to_string(~H"""
        <.next_link page_number={3} total_pages={5} />
        """)

      assert "<a href=\"?page=4\">Next &gt;</a>" == c
    end

    test "internationalization" do
      assigns = %{params: %{}, query_string: "", page_number: 2, total_pages: 3}

      set_locale("en")

      c =
        rendered_to_string(~H"""
        <.next_link page_number={@page_number} total_pages={@total_pages} query_string={@query_string} conn_params={@params} />
        """)

      assert c =~ "Next &gt;"

      set_locale("ru")

      c =
        rendered_to_string(~H"""
        <.next_link page_number={@page_number} total_pages={@total_pages} query_string={@query_string} conn_params={@params} />
        """)

      assert c =~ "Следующая"

      set_locale("es")

      c =
        rendered_to_string(~H"""
        <.next_link page_number={@page_number} total_pages={@total_pages} query_string={@query_string} conn_params={@params} />
        """)

      assert c =~ "Sig &gt;"
    end
  end

  defp set_locale(locale) when is_bitstring(locale) do
    Gettext.put_locale(Torch.Gettext, locale)
  end
end

defmodule Phx18Web.ErrorJSONTest do
  use Phx18Web.ConnCase, async: true

  test "renders 404" do
    assert Phx18Web.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Phx18Web.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end

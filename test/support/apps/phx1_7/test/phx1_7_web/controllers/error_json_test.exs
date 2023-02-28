defmodule Phx17Web.ErrorJSONTest do
  use Phx17Web.ConnCase, async: true

  test "renders 404" do
    assert Phx17Web.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Phx17Web.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end

defmodule <%= module %>ControllerTest do
  alias <%= base %>.<%= String.capitalize(singular) %>

  use <%= base %>.ConnCase

  @valid_attrs <%= inspect params %>
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, <%= namespace_underscore %>_<%= singular %>_path(conn, :index)
    assert html_response(conn, 200) =~ "<%= String.capitalize(plural) %>"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, <%= namespace_underscore %>_<%= singular %>_path(conn, :new)
    assert html_response(conn, 200) =~ "New <%= String.capitalize(singular) %>"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, <%= namespace_underscore %>_<%= singular %>_path(conn, :create), <%= singular %>: @valid_attrs
    assert redirected_to(conn) == <%= namespace_underscore %>_<%= singular %>_path(conn, :index)
    assert Repo.get_by(<%= alias %>, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, <%= namespace_underscore %>_<%= singular %>_path(conn, :create), <%= singular %>: @invalid_attrs
    assert html_response(conn, 400) =~ "New <%= String.capitalize(singular) %>"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    <%= singular %> = Repo.insert! %<%= alias %>{}
    conn = get conn, <%= namespace_underscore %>_<%= singular %>_path(conn, :edit, <%= singular %>)
    assert html_response(conn, 200) =~ "Edit <%= String.capitalize(singular) %>"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    <%= singular %> = Repo.insert! %<%= alias %>{}
    conn = put conn, <%= namespace_underscore %>_<%= singular %>_path(conn, :update, <%= singular %>), <%= singular %>: @valid_attrs
    assert redirected_to(conn) == <%= namespace_underscore %>_<%= singular %>_path(conn, :index)
    assert Repo.get_by(<%= alias %>, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    <%= singular %> = Repo.insert! %<%= alias %>{}
    conn = put conn, <%= namespace_underscore %>_<%= singular %>_path(conn, :update, <%= singular %>), <%= singular %>: @invalid_attrs
    assert html_response(conn, 400) =~ "Edit <%= String.capitalize(singular) %>"
  end

  test "deletes chosen resource", %{conn: conn} do
    <%= singular %> = Repo.insert! %<%= alias %>{}
    conn = delete conn, <%= namespace_underscore %>_<%= singular %>_path(conn, :delete, <%= singular %>)
    assert redirected_to(conn) == <%= namespace_underscore %>_<%= singular %>_path(conn, :index)
    refute Repo.get(<%= alias %>, <%= singular %>.id)
  end
end
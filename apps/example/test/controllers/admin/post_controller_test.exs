defmodule Example.Admin.PostControllerTest do
  use Example.ConnCase

  alias Example.Post

  describe ".index" do
    test "displays all posts when filters are not set", %{conn: conn} do
      post = Repo.insert! %Post{title: "My Best Day", body: "testing"}
      response =
        conn
        |> get(admin_post_path(conn, :index))
        |> html_response(200)

      assert response =~ post.title
    end

    test "displays matching posts when filters are set", %{conn: conn} do
      post = Repo.insert! %Post{title: "My Best Day"}
      Repo.insert! %Post{title: "My Worst Day"}

      response =
        conn
        |> get(admin_post_path(conn, :index, %{post: %{title_contains: "best"}}))
        |> html_response(200)

      assert response =~ post.title
      refute response =~ "My Worst Day"
    end
  end

  describe ".new" do
    test "renders a form", %{conn: conn} do
      response =
        conn
        |> get(admin_post_path(conn, :new))
        |> html_response(200)

      assert response =~ "<form"
    end
  end

  describe ".create" do
    test "creates a post when params are valid", %{conn: conn} do
      params = %{
        title: "My Best Day",
        draft: true,
        body: "Some body text"
      }

      conn = post(conn, admin_post_path(conn, :create), %{post: params})

      assert redirected_to(conn) == admin_post_path(conn, :index)
      assert Repo.get_by(Post, params)
    end

    test "renders validation errors when params are invalid", %{conn: conn} do
      conn = post(conn, admin_post_path(conn, :create), %{post: %{}})

      assert html_response(conn, 400) =~ "Oops"
    end
  end

  describe ".edit" do
    test "renders a form", %{conn: conn} do
      post = Repo.insert! %Post{}
      response =
        conn
        |> get(admin_post_path(conn, :edit, post))
        |> html_response(200)

      assert response =~ "<form"
    end
  end

  describe ".update" do
    test "updates a post when params are valid", %{conn: conn} do
      post = Repo.insert! %Post{title: "My Best Day", body: "Something"}
      params = %{title: "My Worst Day"}
      conn = put(conn, admin_post_path(conn, :update, post), %{post: params})

      assert redirected_to(conn) =~ admin_post_path(conn, :index)
      assert Repo.get_by(Post, params)
    end
  end

  describe ".delete" do
    test "deletes a post", %{conn: conn} do
      post = Repo.insert! %Post{}
      delete(conn, admin_post_path(conn, :delete, post))

      refute Repo.get(Post, post.id)
    end
  end
end

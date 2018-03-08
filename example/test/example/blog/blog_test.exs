defmodule Example.BlogTest do
  use Example.DataCase

  alias Example.Blog

  describe "posts" do
    alias Example.Blog.Post

    @valid_attrs %{description: "some description", published: true, published_at: "2010-04-17 14:00:00.000000Z", subtitle: "some subtitle", title: "some title", views: 42}
    @update_attrs %{description: "some updated description", published: false, published_at: "2011-05-18 15:01:01.000000Z", subtitle: "some updated subtitle", title: "some updated title", views: 43}
    @invalid_attrs %{description: nil, published: nil, published_at: nil, subtitle: nil, title: nil, views: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blog.create_post()

      post
    end

    test "paginate_posts/1 returns paginated list of posts" do
      for _ <- 1..20 do
        post_fixture()
      end

      {:ok, %{posts: posts} = page} = Blog.paginate_posts(%{})

      assert length(posts) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Blog.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Blog.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Blog.create_post(@valid_attrs)
      assert post.description == "some description"
      assert post.published == true
      assert post.published_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert post.subtitle == "some subtitle"
      assert post.title == "some title"
      assert post.views == 42
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, post} = Blog.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.description == "some updated description"
      assert post.published == false
      assert post.published_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert post.subtitle == "some updated subtitle"
      assert post.title == "some updated title"
      assert post.views == 43
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert post == Blog.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Blog.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end
end

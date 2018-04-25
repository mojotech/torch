defmodule Example.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Example.Repo
import Torch.Helpers, only: [sort: 1, paginate: 4]
import Filtrex.Type.Config

alias Example.Blog.Post

@pagination [page_size: 15]
@pagination_distance 5

@doc """
Paginate the list of posts using filtrex
filters.

## Examples

    iex> list_posts(%{})
    %{posts: [%Post{}], ...}
"""
@spec paginate_posts(map) :: {:ok, map} | {:error, any}
def paginate_posts(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_config(:posts), params["post"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_posts(filter, params) do
    {:ok,
      %{
        posts: page.entries,
        page_number: page.page_number,
        page_size: page.page_size,
        total_pages: page.total_pages,
        total_entries: page.total_entries,
        distance: @pagination_distance,
        sort_field: sort_field,
        sort_direction: sort_direction
      }
    }
  else
    {:error, error} -> {:error, error}
    error -> {:error, error}
  end
end

defp do_paginate_posts(filter, params) do
  Post
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of posts.

## Examples

    iex> list_posts()
    [%Post{}, ...]

"""
def list_posts do
  Repo.all(Post)
end

@doc """
Gets a single post.

Raises `Ecto.NoResultsError` if the Post does not exist.

## Examples

    iex> get_post!(123)
    %Post{}

    iex> get_post!(456)
    ** (Ecto.NoResultsError)

"""
def get_post!(id), do: Repo.get!(Post, id)

@doc """
Creates a post.

## Examples

    iex> create_post(%{field: value})
    {:ok, %Post{}}

    iex> create_post(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_post(attrs \\ %{}) do
  %Post{}
  |> Post.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a post.

## Examples

    iex> update_post(post, %{field: new_value})
    {:ok, %Post{}}

    iex> update_post(post, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_post(%Post{} = post, attrs) do
  post
  |> Post.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a Post.

## Examples

    iex> delete_post(post)
    {:ok, %Post{}}

    iex> delete_post(post)
    {:error, %Ecto.Changeset{}}

"""
def delete_post(%Post{} = post) do
  Repo.delete(post)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking post changes.

## Examples

    iex> change_post(post)
    %Ecto.Changeset{source: %Post{}}

"""
def change_post(%Post{} = post) do
  Post.changeset(post, %{})
end

defp filter_config(:posts) do
  defconfig do
    text :title
      text :subtitle
      text :description
      date :published_at
      boolean :published
      number :views
      
  end
end
end

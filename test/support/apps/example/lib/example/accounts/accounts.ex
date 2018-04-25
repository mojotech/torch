defmodule Example.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Example.Repo
import Torch.Helpers, only: [sort: 1, paginate: 4]
import Filtrex.Type.Config

alias Example.Accounts.User

@pagination [page_size: 15]
@pagination_distance 5

@doc """
Paginate the list of users using filtrex
filters.

## Examples

    iex> list_users(%{})
    %{users: [%User{}], ...}
"""
@spec paginate_users(map) :: {:ok, map} | {:error, any}
def paginate_users(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_config(:users), params["user"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_users(filter, params) do
    {:ok,
      %{
        users: page.entries,
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

defp do_paginate_users(filter, params) do
  User
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of users.

## Examples

    iex> list_users()
    [%User{}, ...]

"""
def list_users do
  Repo.all(User)
end

@doc """
Gets a single user.

Raises `Ecto.NoResultsError` if the User does not exist.

## Examples

    iex> get_user!(123)
    %User{}

    iex> get_user!(456)
    ** (Ecto.NoResultsError)

"""
def get_user!(id), do: Repo.get!(User, id)

@doc """
Creates a user.

## Examples

    iex> create_user(%{field: value})
    {:ok, %User{}}

    iex> create_user(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_user(attrs \\ %{}) do
  %User{}
  |> User.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a user.

## Examples

    iex> update_user(user, %{field: new_value})
    {:ok, %User{}}

    iex> update_user(user, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_user(%User{} = user, attrs) do
  user
  |> User.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a User.

## Examples

    iex> delete_user(user)
    {:ok, %User{}}

    iex> delete_user(user)
    {:error, %Ecto.Changeset{}}

"""
def delete_user(%User{} = user) do
  Repo.delete(user)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking user changes.

## Examples

    iex> change_user(user)
    %Ecto.Changeset{source: %User{}}

"""
def change_user(%User{} = user) do
  User.changeset(user, %{})
end

defp filter_config(:users) do
  defconfig do
    text :name
      text :email
      boolean :sign_up_complete
      date :signed_up_at
      
  end
end
end


  import Torch.Helpers, only: [sort: 1, paginate: 4, strip_unset_booleans: 3]
  import Filtrex.Type.Config

  alias <%= inspect schema.module %>

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of <%= schema.plural %> using filtrex
  filters.

  ## Examples

      iex> paginate_<%= schema.plural %>(%{})
      %{<%= schema.plural %>: [%<%= inspect schema.alias %>{}], ...}

  """
  @spec paginate_<%= schema.plural %>(map) :: {:ok, map} | {:error, any}
  def paginate_<%= schema.plural %>(params \\ %{}) do
    params =
      params
      |> strip_unset_booleans("<%= schema.singular %>", [<%= Enum.reduce(schema.attrs, [], &(if elem(&1, 1) == :boolean, do: [inspect(elem(&1, 0)) | &2], else: &2)) %>])
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(<%= inspect String.to_atom(schema.plural) %>), params["<%= schema.singular %>"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_<%= schema.plural %>(filter, params) do
      {:ok,
        %{
          <%= schema.plural %>: page.entries,
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

  defp do_paginate_<%= schema.plural %>(filter, params) do
    raise "TODO"
  end

  @doc """
  Returns the list of <%= schema.plural %>.

  ## Examples

      iex> list_<%= schema.plural %>()
      [%<%= inspect schema.alias %>{}, ...]

  """
  def list_<%= schema.plural %> do
    raise "TODO"
  end

  @doc """
  Gets a single <%= schema.singular %>.

  Raises `Ecto.NoResultsError` if the <%= schema.human_singular %> does not exist.

  ## Examples

      iex> get_<%= schema.singular %>!(123)
      %<%= inspect schema.alias %>{}

      iex> get_<%= schema.singular %>!(456)
      ** (Ecto.NoResultsError)

  """
  def get_<%= schema.singular %>!(id), do: raise "TODO"

  @doc """
  Creates a <%= schema.singular %>.

  ## Examples

      iex> create_<%= schema.singular %>(%{field: value})
      {:ok, %<%= inspect schema.alias %>{}}

      iex> create_<%= schema.singular %>(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_<%= schema.singular %>(attrs \\ %{}) do
    raise "TODO"
  end

  @doc """
  Updates a <%= schema.singular %>.

  ## Examples

      iex> update_<%= schema.singular %>(<%= schema.singular %>, %{field: new_value})
      {:ok, %<%= inspect schema.alias %>{}}

      iex> update_<%= schema.singular %>(<%= schema.singular %>, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_<%= schema.singular %>(%<%= inspect schema.alias %>{} = <%= schema.singular %>, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a <%= inspect schema.alias %>.

  ## Examples

      iex> delete_<%= schema.singular %>(<%= schema.singular %>)
      {:ok, %<%= inspect schema.alias %>{}}

      iex> delete_<%= schema.singular %>(<%= schema.singular %>)
      {:error, %Ecto.Changeset{}}

  """
  def delete_<%= schema.singular %>(%<%= inspect schema.alias %>{} = <%= schema.singular %>) do
    raise "TODO"
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking <%= schema.singular %> changes.

  ## Examples

      iex> change_<%= schema.singular %>(<%= schema.singular %>)
      %Ecto.Changeset{source: %<%= inspect schema.alias %>{}}

  """
  def change_<%= schema.singular %>(%<%= inspect schema.alias %>{} = <%= schema.singular %>, _attrs \\ %{}) do
    raise "TODO"
  end

  defp filter_config(<%= inspect String.to_atom(schema.plural) %>) do
    raise "TODO"
  end

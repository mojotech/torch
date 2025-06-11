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

    # Convert params to Flop format
    flop_params = %{
      "page" => params["page"] || 1,
      "page_size" => @pagination |> Keyword.get(:page_size),
      "order_by" => [sort_field],
      "order_directions" => [sort_direction]
    }

    # Add filters from params if they exist
    flop_params =
      if Map.has_key?(params, "<%= schema.singular %>") do
        filters = convert_filtrex_to_flop_filters(params["<%= schema.singular %>"])
        Map.put(flop_params, "filters", filters)
      else
        flop_params
      end

    # Use Flop to validate and run the query
    case Flop.validate_and_run(<%= inspect schema.alias %>, flop_params, for: <%= inspect schema.alias %>) do
      {:ok, {entries, meta}} ->
        {:ok,
         %{
           <%= schema.plural %>: entries,
           page_number: meta.current_page || 1,
           page_size: meta.page_size,
           total_pages: meta.total_pages,
           total_entries: meta.total_count,
           distance: @pagination_distance,
           sort_field: sort_field,
           sort_direction: sort_direction
         }}

      {:error, error} ->
        {:error, error}
    end
  end

  # Helper function to convert Filtrex filters to Flop filters
  defp convert_filtrex_to_flop_filters(filtrex_params) do
    filtrex_params
    |> Enum.map(fn {key, value} ->
      # Parse the key to extract field and operator
      {field, op} = parse_filtrex_key(key)
      
      # Convert to Flop filter format
      %{
        "field" => field,
        "op" => convert_filtrex_op_to_flop(op),
        "value" => value
      }
    end)
    |> Enum.filter(fn filter -> filter["value"] != nil && filter["value"] != "" end)
  end

  # Parse Filtrex key format (e.g., "name_contains") to field and operator
  defp parse_filtrex_key(key) do
    key = to_string(key)
    
    cond do
      String.ends_with?(key, "_contains") ->
        {String.replace(key, "_contains", ""), "contains"}
      String.ends_with?(key, "_equals") ->
        {String.replace(key, "_equals", ""), "equals"}
      String.ends_with?(key, "_greater_than") ->
        {String.replace(key, "_greater_than", ""), "greater_than"}
      String.ends_with?(key, "_greater_than_or_equal_to") ->
        {String.replace(key, "_greater_than_or_equal_to", ""), "greater_than_or_equal_to"}
      String.ends_with?(key, "_less_than") ->
        {String.replace(key, "_less_than", ""), "less_than"}
      String.ends_with?(key, "_less_than_or_equal_to") ->
        {String.replace(key, "_less_than_or_equal_to", ""), "less_than_or_equal_to"}
      true ->
        {key, "equals"}
    end
  end

  # Convert Filtrex operators to Flop operators
  defp convert_filtrex_op_to_flop("contains"), do: "ilike"
  defp convert_filtrex_op_to_flop("equals"), do: "=="
  defp convert_filtrex_op_to_flop("greater_than"), do: ">"
  defp convert_filtrex_op_to_flop("greater_than_or_equal_to"), do: ">="
  defp convert_filtrex_op_to_flop("less_than"), do: "<"
  defp convert_filtrex_op_to_flop("less_than_or_equal_to"), do: "<="
  defp convert_filtrex_op_to_flop(_), do: "=="

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

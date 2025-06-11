defmodule Torch.FlopAdapter do
  @moduledoc """
  Adapter module to bridge between Scrivener and Flop APIs.
  
  This module provides compatibility functions to help with the migration
  from Scrivener to Flop. It allows Torch to use Flop internally while
  maintaining a Scrivener-compatible interface for backward compatibility.
  """

  @doc """
  Converts a Flop.Meta struct to a Scrivener.Page-compatible map.
  
  This function takes the result of a Flop query and converts it to a format
  that is compatible with the Scrivener.Page struct, which is expected by
  existing Torch code.
  
  ## Parameters
  
  - `entries`: The list of entries returned by Flop
  - `meta`: The Flop.Meta struct containing pagination metadata
  
  ## Returns
  
  A map with the same structure as a Scrivener.Page struct
  """
  def to_scrivener_page(entries, %Flop.Meta{} = meta) do
    %{
      entries: entries,
      page_number: meta.current_page || 1,
      page_size: meta.page_size,
      total_pages: meta.total_pages,
      total_entries: meta.total_count
    }
  end

  @doc """
  Paginates a query using Flop but returns a Scrivener.Page-compatible result.
  
  This function is a drop-in replacement for Scrivener.paginate/2 that uses
  Flop internally. It converts the Flop pagination parameters to Scrivener format
  and vice versa for the result.
  
  ## Parameters
  
  - `queryable`: An Ecto.Queryable to paginate
  - `flop_or_opts`: Either a Flop struct or pagination options
  - `repo`: The Ecto repo to use for the query (optional if configured globally)
  
  ## Returns
  
  A map with the same structure as a Scrivener.Page struct
  """
  def paginate(queryable, flop_or_opts, repo \\ nil) do
    repo = repo || Application.get_env(:flop, :repo)
    
    flop = normalize_options(flop_or_opts)
    
    case Flop.validate_and_run(queryable, flop, for: nil, repo: repo) do
      {:ok, {entries, meta}} ->
        to_scrivener_page(entries, meta)
      {:error, _changeset} ->
        # Return empty page on error for compatibility
        %{
          entries: [],
          page_number: 1,
          page_size: flop.page_size || 10,
          total_pages: 0,
          total_entries: 0
        }
    end
  end

  @doc """
  Converts Scrivener-style pagination options to a Flop struct.
  
  ## Parameters
  
  - `opts`: Pagination options in Scrivener format
  
  ## Returns
  
  A Flop struct with equivalent pagination settings
  """
  def normalize_options(%Flop{} = flop), do: flop
  
  def normalize_options(%{page: page, page_size: page_size} = opts) do
    filters = Map.get(opts, :filters, [])
    order_by = Map.get(opts, :order_by, [])
    order_directions = Map.get(opts, :order_directions, [])
    
    %Flop{
      page: page,
      page_size: page_size,
      filters: filters,
      order_by: order_by,
      order_directions: order_directions
    }
  end
  
  def normalize_options(%Scrivener.Config{page_number: page_number, page_size: page_size}) do
    %Flop{
      page: page_number,
      page_size: page_size
    }
  end
  
  def normalize_options(opts) when is_list(opts) do
    page = Keyword.get(opts, :page, 1)
    page_size = Keyword.get(opts, :page_size, 10)
    
    %Flop{
      page: page,
      page_size: page_size
    }
  end
  
  def normalize_options(_), do: %Flop{page: 1, page_size: 10}

  @doc """
  Converts Scrivener-style sort parameters to Flop format.
  
  ## Parameters
  
  - `direction`: Sort direction as atom (:asc or :desc)
  - `field`: Field to sort by as atom
  
  ## Returns
  
  A tuple with order_by and order_directions lists for Flop
  """
  def convert_sort(direction, field) do
    {[field], [direction]}
  end
end

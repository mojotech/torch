defmodule Radmin.Query do
  import Ecto.Query

  def query(model, opts) do
    {:ok, filter} = Filtrex.parse_params(opts[:filtrex], opts[:params] || %{})

    model
    |> Filtrex.query(filter)
    |> page(opts[:page], opts[:page_size])
  end

  defp page(model, nil, page_size) do
    model
    |> offset(0)
    |> limit(^page_size)
  end
  defp page(model, page, page_size) when is_binary(page) do
    page(model, page_size, String.to_integer(page))
  end
  defp page(model, page, page_size) do
    offset = page * page_size
    model
    |> offset(^offset)
    |> limit(^page_size)
  end
end

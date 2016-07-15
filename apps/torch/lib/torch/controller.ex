defmodule Torch.Controller do
  def sort(%{"sort_field" => field, "sort_direction" => direction}) do
    {String.to_atom(direction), String.to_atom(field)}
  end
  def sort(_other) do
    {:asc, :id}
  end

  def paginate(query, repo, params, settings \\ [page_size: 10]) do
    Scrivener.paginate(query, Scrivener.Config.new(repo, settings, params))
  end
end

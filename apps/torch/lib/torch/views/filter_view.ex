defmodule Torch.FilterView do
  use Phoenix.HTML

  def filter_select(prefix, field, params) do
    prefix_str = to_string(prefix)
    {selected, _value} = find_param(params[prefix_str], field)

    opts = [
      {"Contains", "#{prefix}[#{field}_contains]"},
      {"Equals", "#{prefix}[#{field}_equals]"}
    ]

    select(:filters, "", opts, class: "filter-type", value: "#{prefix}[#{selected}]")
  end

  def filter_string_input(prefix, field, params) do
    prefix_str = to_string(prefix)
    {name, value} = find_param(params[prefix_str], field)
    text_input(prefix, String.to_atom(name), value: value)
  end

  def filter_text_input(prefix, field, params) do
    filter_string_input(prefix, field, params)
  end

  def filter_date_input(prefix, field, params) do
    prefix = to_string(prefix)
    field = to_string(field)
    {:safe, start} = date_input("#{prefix}[#{field}_between][start]", get_in(params, [prefix, "#{field}_between", "start"]))
    {:safe, ending} = date_input("#{prefix}[#{field}_between][end]", get_in(params, [prefix, "#{field}_between", "end"]))
    raw(start <> ending)
  end

  defp date_input(name, value) do
    tag :input, type: "text", class: "datepicker", name: name, value: value
  end

  defp find_param(params, pattern) do
    pattern = to_string(pattern)
    result =
      Enum.find params || %{}, fn {key, _val} ->
        String.starts_with?(key, pattern)
      end

    case result do
      nil -> {"#{pattern}_contains", nil}
      other -> other
    end
  end
end

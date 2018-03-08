defmodule Torch.FilterView do
  @moduledoc """
  Provides input generators for Torch's filter sidebar.
  """

  use Phoenix.HTML

  @doc """
  Generates a select box for a `belongs_to` association.

  ## Example

      filter_assoc_select(:post, :category_id, [{"Articles", 1}], %{"post" => %{"category_id_equals" => 1}})
  """
  def filter_assoc_select(prefix, field, options, params) do
    select(
      prefix,
      :"#{field}_equals",
      options,
      value: params[to_string(prefix)]["#{field}_equals"],
      prompt: "Choose one"
    )
  end

  @doc """
  Generates a "contains/equals" filter type select box for a given `string` or
  `text` field.

  ## Example

      filter_select(:post, :title, params)
  """
  def filter_select(prefix, field, params) do
    prefix_str = to_string(prefix)
    {selected, _value} = find_param(params[prefix_str], field)

    opts = [
      {"Contains", "#{prefix}[#{field}_contains]"},
      {"Equals", "#{prefix}[#{field}_equals]"}
    ]

    select(:filters, "", opts, class: "filter-type", value: "#{prefix}[#{selected}]")
  end

  @doc """
  Generates a number filter type select box for a given `number` field.

  ## Example

      number_filter_select(:post, :rating, params)
  """
  def number_filter_select(prefix, field, params) do
    prefix_str = to_string(prefix)
    {selected, _value} = find_param(params[prefix_str], field)

    opts = [
      {"Equals", "#{prefix}[#{field}_equals]"},
      {"Greater Than", "#{prefix}[#{field}_greater_than]"},
      {"Greater Than Or Equal", "#{prefix}[#{field}_greater_than_or]"},
      {"Less Than", "#{prefix}[#{field}_less_than]"}
    ]

    select(:filters, "", opts, class: "filter-type", value: "#{prefix}[#{selected}]")
  end

  @doc """
  Generates a filter input for a number field.

  ## Example

      filter_number_input(:post, :rating, params)
  """
  def filter_number_input(prefix, field, params) do
    prefix_str = to_string(prefix)
    {name, value} = find_param(params[prefix_str], field, :number)
    text_input(prefix, String.to_atom(name), value: value, type: "number")
  end

  @doc """
  Generates a filter input for a string field.

  ## Example

      filter_string_input(:post, :title, params)
  """
  def filter_string_input(prefix, field, params) do
    prefix_str = to_string(prefix)
    {name, value} = find_param(params[prefix_str], field)
    text_input(prefix, String.to_atom(name), value: value)
  end

  @doc """
  Generates a filter input for a text field.

  ## Example

      filter_text_input(:post, :body, params)
  """
  def filter_text_input(prefix, field, params) do
    filter_string_input(prefix, field, params)
  end

  @doc """
  Generates a filter datepicker input.

  ## Example

      filter_date_input(:post, :inserted_at, params)
  """
  def filter_date_input(prefix, field, params) do
    prefix = to_string(prefix)
    field = to_string(field)

    {:safe, start} =
      date_input(
        "#{prefix}[#{field}_between][start]",
        get_in(params, [prefix, "#{field}_between", "start"]),
        "start"
      )

    {:safe, ending} =
      date_input(
        "#{prefix}[#{field}_between][end]",
        get_in(params, [prefix, "#{field}_between", "end"]),
        "end"
      )

    raw(start ++ ending)
  end

  @doc """
  Generates a filter select box for a boolean field.

  ## Example

      filter_boolean_input(:post, :draft, params)
  """
  def filter_boolean_input(prefix, field, params) do
    value =
      case get_in(params, [to_string(prefix), "#{field}_equals"]) do
        nil -> nil
        string when is_binary(string) -> string == "true"
      end

    select(
      prefix,
      :"#{field}_equals",
      [{"True", true}, {"False", false}],
      value: value,
      prompt: "Choose one"
    )
  end

  defp date_input(name, value, "start") do
    tag(
      :input,
      type: "text",
      class: "datepicker start",
      name: name,
      value: value,
      placeholder: "Select Start Date"
    )
  end

  defp date_input(name, value, "end") do
    tag(
      :input,
      type: "text",
      class: "datepicker end",
      name: name,
      value: value,
      placeholder: "Select End Date"
    )
  end

  defp date_input(name, value, class) do
    tag(:input, type: "text", class: "datepicker #{class}", name: name, value: value)
  end

  defp find_param(params, pattern, type \\ :string) do
    pattern = to_string(pattern)

    result =
      Enum.find(params || %{}, fn {key, _val} ->
        String.starts_with?(key, pattern)
      end)

    cond do
      result == nil && type == :string -> {"#{pattern}_contains", nil}
      result == nil && type == :number -> {"#{pattern}_equals", nil}
      result != nil -> result
    end
  end
end
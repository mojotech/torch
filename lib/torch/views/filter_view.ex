defmodule Torch.FilterView do
  @moduledoc """
  Provides input generators for Torch's filter sidebar.
  """

  import Phoenix.HTML
  use PhoenixHTMLHelpers

  import Torch.I18n, only: [message: 1]

  @type prefix :: atom | String.t()
  @type field :: atom | String.t()
  @type input_type :: atom | String.t()

  @doc """
  Generates a select box for a `belongs_to` association.

  ## Example

      iex> params = %{"post" => %{"category_id_equals" => 1}}
      ...> filter_assoc_select(:post, :category_id, [{"Articles", 1}], params) |> safe_to_string()
      "<select id=\\"post_category_id_equals\\" name=\\"post[category_id_equals]\\"><option value=\\"\\">Choose one</option><option selected value=\\"1\\">Articles</option></select>"
  """
  @spec filter_assoc_select(prefix, field, list, map) :: Phoenix.HTML.safe()
  def filter_assoc_select(prefix, field, options, params) do
    select(
      prefix,
      :"#{field}_equals",
      options,
      value: params[to_string(prefix)]["#{field}_equals"],
      prompt: message("Choose one")
    )
  end

  @doc """
  Generates a "contains/equals" filter type select box for a given `string` or
  `text` field.

  ## Example

      iex> params = %{"post" => %{"title_contains" => "test"}}
      ...> filter_select(:post, :title, params) |> safe_to_string()
      "<select class=\\"filter-type\\" id=\\"filters_\\" name=\\"filters[]\\"><option selected value=\\"post[title_contains]\\">Contains</option><option value=\\"post[title_equals]\\">Equals</option></select>"
  """
  @spec filter_select(prefix, field, map) :: Phoenix.HTML.safe()
  def filter_select(prefix, field, params) do
    prefix_str = to_string(prefix)
    {selected, _value} = find_param(params[prefix_str], field, :select)

    opts = [
      {message("Contains"), "#{prefix}[#{field}_contains]"},
      {message("Equals"), "#{prefix}[#{field}_equals]"}
    ]

    select(:filters, "", opts, class: "filter-type", value: "#{prefix}[#{selected}]")
  end

  @doc """
  Generates a "before/after" filter type select box for a given `date` or
  `datetime` field.

  ## Example

      iex> params = %{"post" => %{"updated_at_after" => "01/01/2019"}}
      ...> filter_date_select(:post, :updated_at, params) |> safe_to_string()
      "<select class=\\"filter-type\\" id=\\"filters_\\" name=\\"filters[]\\"><option value=\\"post[updated_at_before]\\">Before</option><option selected value=\\"post[updated_at_after]\\">After</option></select>"
  """
  @spec filter_date_select(prefix, field, map) :: Phoenix.HTML.safe()
  def filter_date_select(prefix, field, params) do
    prefix_str = to_string(prefix)
    {selected, _value} = find_param(params[prefix_str], field, :date_select)

    opts = [
      {message("Before"), "#{prefix}[#{field}_before]"},
      {message("After"), "#{prefix}[#{field}_after]"}
    ]

    select(:filters, "", opts, class: "filter-type", value: "#{prefix}[#{selected}]")
  end

  @doc """
  Generates a number filter type select box for a given `number` field.

  ## Example

      iex> params = %{"post" => %{"rating_greater_than" => 0}}
      ...> number_filter_select(:post, :rating, params) |> safe_to_string()
      "<select class=\\"filter-type\\" id=\\"filters_\\" name=\\"filters[]\\"><option value=\\"post[rating_equals]\\">Equals</option><option selected value=\\"post[rating_greater_than]\\">Greater Than</option><option value=\\"post[rating_greater_than_or]\\">Greater Than Or Equal</option><option value=\\"post[rating_less_than]\\">Less Than</option></select>"
  """
  @spec number_filter_select(prefix, field, map) :: Phoenix.HTML.safe()
  def number_filter_select(prefix, field, params) do
    prefix_str = to_string(prefix)
    {selected, _value} = find_param(params[prefix_str], field, :number_select)

    opts = [
      {message("Equals"), "#{prefix}[#{field}_equals]"},
      {message("Greater Than"), "#{prefix}[#{field}_greater_than]"},
      {message("Greater Than Or Equal"), "#{prefix}[#{field}_greater_than_or]"},
      {message("Less Than"), "#{prefix}[#{field}_less_than]"}
    ]

    select(:filters, "", opts, class: "filter-type", value: "#{prefix}[#{selected}]")
  end

  @doc """
  Generates a filter input for a number field.

  ## Example

      iex> params = %{"post" => %{"rating_equals" => 5}}
      ...> filter_number_input(:post, :rating, params) |> safe_to_string()
      "<input id=\\"post_rating_equals\\" name=\\"post[rating_equals]\\" type=\\"number\\" value=\\"5\\">"

      iex> params = %{"post" => %{"rating_greater_than_or" => 15}}
      ...> filter_number_input(:post, :rating, params) |> safe_to_string()
      "<input id=\\"post_rating_greater_than_or\\" name=\\"post[rating_greater_than_or]\\" type=\\"number\\" value=\\"15\\">"

      iex> params = %{"post" => %{"rating_greater_than" => 15}}
      ...> filter_number_input(:post, :rating, params) |> safe_to_string()
      "<input id=\\"post_rating_greater_than\\" name=\\"post[rating_greater_than]\\" type=\\"number\\" value=\\"15\\">"

      iex> params = %{"post" => %{"rating_less_than" => 18}}
      ...> filter_number_input(:post, :rating, params) |> safe_to_string()
      "<input id=\\"post_rating_less_than\\" name=\\"post[rating_less_than]\\" type=\\"number\\" value=\\"18\\">"
  """
  @spec filter_number_input(prefix, field, map) :: Phoenix.HTML.safe()
  def filter_number_input(prefix, field, params) do
    prefix_str = to_string(prefix)
    {name, value} = find_param(params[prefix_str], field, :number_select)
    text_input(prefix, String.to_atom(name), value: value, type: "number")
  end

  @doc """
  Generates a filter input for a string field.

  ## Example

      iex> params = %{"post" => %{"title_contains" => "test"}}
      iex> filter_string_input(:post, :title, params) |> safe_to_string()
      "<input id=\\"post_title_contains\\" name=\\"post[title_contains]\\" type=\\"text\\" value=\\"test\\">"

      iex> params = %{"post" => %{"board_title_contains" => "board test", "title_contains" => "test"}}
      iex> filter_string_input(:post, :title, params) |> safe_to_string()
      "<input id=\\"post_title_contains\\" name=\\"post[title_contains]\\" type=\\"text\\" value=\\"test\\">"
  """
  @spec filter_string_input(prefix, field, map) :: Phoenix.HTML.safe()
  def filter_string_input(prefix, field, params) do
    prefix_str = to_string(prefix)
    {name, value} = find_param(params[prefix_str], field, :select)
    text_input(prefix, String.to_atom(name), value: value)
  end

  @doc """
  Generates a filter datepicker input.

  ## Example

      iex> params = %{"post" => %{"inserted_at_between" => %{"start" => "01/01/2018", "end" => "01/31/2018"}}}
      ...> filter_date_input(:post, :inserted_at, params) |> safe_to_string()
      "<input class=\\"datepicker start\\" name=\\"post[inserted_at_between][start]\\" placeholder=\\"Select Start Date\\" type=\\"text\\" value=\\"01/01/2018\\"><input class=\\"datepicker end\\" name=\\"post[inserted_at_between][end]\\" placeholder=\\"Select End Date\\" type=\\"text\\" value=\\"01/31/2018\\">"

      iex> params = %{"post" => %{"inserted_at_between" => %{"start" => "01/01/2018", "end" => "01/31/2018"}}}
      ...> filter_date_input(:post, :inserted_at, params, :range) |> safe_to_string()
      "<input class=\\"datepicker start\\" name=\\"post[inserted_at_between][start]\\" placeholder=\\"Select Start Date\\" type=\\"text\\" value=\\"01/01/2018\\"><input class=\\"datepicker end\\" name=\\"post[inserted_at_between][end]\\" placeholder=\\"Select End Date\\" type=\\"text\\" value=\\"01/31/2018\\">"

      iex> params = %{"post" => %{"inserted_at_before" => "01/01/2018"}}
      ...> filter_date_input(:post, :inserted_at, params, :select) |> safe_to_string()
      "<input class=\\"datepicker\\" name=\\"post[inserted_at_before]\\" placeholder=\\"Select Date\\" type=\\"text\\" value=\\"01/01/2018\\">"

      iex> params = %{"post" => %{"inserted_at_after" => "01/01/2018"}}
      ...> filter_date_input(:post, :inserted_at, params, :select) |> safe_to_string()
      "<input class=\\"datepicker\\" name=\\"post[inserted_at_after]\\" placeholder=\\"Select Date\\" type=\\"text\\" value=\\"01/01/2018\\">"
  """
  @spec filter_date_input(prefix, field, map, input_type) :: Phoenix.HTML.safe()
  def filter_date_input(prefix, field, params, input_type \\ :range)

  def filter_date_input(prefix, field, params, :range) do
    prefix = to_string(prefix)
    field = to_string(field)

    {:safe, start} =
      torch_date_input(
        "#{prefix}[#{field}_between][start]",
        get_in(params, [prefix, "#{field}_between", "start"]),
        message("start")
      )

    {:safe, ending} =
      torch_date_input(
        "#{prefix}[#{field}_between][end]",
        get_in(params, [prefix, "#{field}_between", "end"]),
        message("end")
      )

    raw(start ++ ending)
  end

  def filter_date_input(prefix, field, params, :select) do
    prefix_str = to_string(prefix)
    {name, value} = find_param(params[prefix_str], field, :date_select)

    {:safe, date_input} =
      torch_date_input(
        "#{prefix}[#{name}]",
        value
      )

    raw(date_input)
  end

  @doc """
  Generates a filter select box for a boolean field.

  ## Example

      iex> params = %{"post" => %{"draft_equals" => "false"}}
      iex> filter_boolean_input(:post, :draft, params) |> safe_to_string()
      "<select class=\\"boolean-type\\" id=\\"post_draft_equals\\" name=\\"post[draft_equals]\\"><option value=\\"any\\"></option><option value=\\"true\\">True</option><option selected value=\\"false\\">False</option></select>"
  """
  @spec filter_boolean_input(prefix, field, map) :: Phoenix.HTML.safe()
  def filter_boolean_input(prefix, field, params) do
    value =
      case get_in(params, [to_string(prefix), "#{field}_equals"]) do
        nil -> "any"
        "any" -> "any"
        string when is_binary(string) -> string == "true"
      end

    opts = [
      {"", "any"},
      {message("True"), "true"},
      {message("False"), "false"}
    ]

    select(prefix, :"#{field}_equals", opts, class: "boolean-type", value: value)
  end

  @doc """
  Generates a "equals" filter type select box for a given `uuid` field
  ## Example
      iex> params = %{"post" => %{"id_equals" => "test"}}
      ...> filter_uuid(:post, :id, params) |> safe_to_string()
      "<select class=\\"filter-type\\" id=\\"filters_\\" name=\\"filters[]\\"><option selected value=\\"post[id_equals]\\">Equals</option></select>"
  """
  @spec filter_uuid(prefix, field, map) :: Phoenix.HTML.safe()
  def filter_uuid(prefix, field, params) do
    prefix_str = to_string(prefix)
    {selected, _value} = find_param(params[prefix_str], field, :equals)

    opts = [
      {message("Equals"), "#{prefix}[#{field}_equals]"}
    ]

    select(:filters, "", opts, class: "filter-type", value: "#{prefix}[#{selected}]")
  end

  defp torch_date_input(name, value) do
    tag(
      :input,
      type: "text",
      class: "datepicker",
      name: name,
      value: value,
      placeholder: message("Select Date")
    )
  end

  defp torch_date_input(name, value, "start") do
    tag(
      :input,
      type: "text",
      class: "datepicker start",
      name: name,
      value: value,
      placeholder: message("Select Start Date")
    )
  end

  defp torch_date_input(name, value, "end") do
    tag(
      :input,
      type: "text",
      class: "datepicker end",
      name: name,
      value: value,
      placeholder: message("Select End Date")
    )
  end

  defp torch_date_input(name, value, class) do
    tag(:input, type: "text", class: "datepicker #{class}", name: name, value: value)
  end

  defp find_param(params, field, :select) do
    do_find_param(params, field, ~w(contains equals))
  end

  defp find_param(params, field, :date_select) do
    do_find_param(params, field, ~w(before after))
  end

  defp find_param(params, field, :number_select) do
    do_find_param(params, field, ~w(equals greater_than greater_than_or less_than))
  end

  defp find_param(params, field, :equals) do
    do_find_param(params, field, "equals")
  end

  defp do_find_param(params, field, comparison) when is_binary(comparison) do
    field = to_string(field)

    result =
      Enum.find(params || %{}, fn {param_name, _val} ->
        param_name == "#{field}_#{comparison}"
      end)

    if is_nil(result) do
      {"#{field}_#{comparison}", nil}
    else
      result
    end
  end

  defp do_find_param(params, field, suffixes) when is_list(suffixes) do
    field = to_string(field)
    suffix_patterns = Enum.join(suffixes, "|")
    default = List.first(suffixes)

    result =
      Enum.find(params || %{}, fn {param_name, _val} ->
        String.match?(param_name, ~r/^#{field}_(?:#{suffix_patterns})/)
      end)

    if is_nil(result) do
      {"#{field}_#{default}", nil}
    else
      result
    end
  end
end

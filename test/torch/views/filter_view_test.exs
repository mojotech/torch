defmodule Torch.FilterViewTest do
  use ExUnit.Case, async: true

  import Phoenix.HTML, only: [safe_to_string: 1]

  doctest Torch.FilterView, import: true

  test "param name prefixes do not collide" do
    # * See GitHub Issue 242: https://github.com/mojotech/torch/issues/242

    params = %{
      "filters" => [
        "user[email_contains]",
        "user[first_name_contains]",
        "user[last_name_contains]",
        "user[id_equals]"
      ],
      "user" => %{
        "email_confirmed_at_between" => %{"end" => "2021-06-03", "start" => "2021-06-08"}
      }
    }

    expected = "<input id=\"user_email_contains\" name=\"user[email_contains]\" type=\"text\">"

    assert expected ==
             safe_to_string(Torch.FilterView.filter_string_input(:user, :email, params))
  end
end

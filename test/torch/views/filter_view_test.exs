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
        "user[id_equals]",
        "user[email_confirmed_at_between]"
      ],
      "user" => %{
        "email_confirmed_at_between" => %{"end" => "2021-06-03", "start" => "2021-06-08"}
      }
    }

    expected = "<input id=\"user_email_contains\" name=\"user[email_contains]\" type=\"text\">"

    assert expected ==
             safe_to_string(Torch.FilterView.filter_string_input(:user, :email, params))
  end

  test "filter select defaults to the correct order" do
    # * See Github Issue 270: https://github.com/mojotech/torch/issues/270

    expected =
      "<select class=\"filter-type\" id=\"filters_\" name=\"filters[]\"><option selected value=\"user[name_contains]\">Contains</option><option value=\"user[name_equals]\">Equals</option></select>"

    assert expected == safe_to_string(Torch.FilterView.filter_select(:user, :name, %{}))

    input_expected =
      "<input id=\"user_name_contains\" name=\"user[name_contains]\" type=\"text\">"

    assert input_expected ==
             safe_to_string(Torch.FilterView.filter_string_input(:user, :name, %{}))
  end

  test "filter select options selected properly based on params" do
    # * See Github Issue 270: https://github.com/mojotech/torch/issues/270

    params = %{
      "filters" => [
        "user[name_equals]",
        "user[email_contains]"
      ],
      "user" => %{
        "name_equals" => "Skywalker"
      }
    }

    expected =
      "<select class=\"filter-type\" id=\"filters_\" name=\"filters[]\"><option value=\"user[name_contains]\">Contains</option><option selected value=\"user[name_equals]\">Equals</option></select>"

    assert expected == safe_to_string(Torch.FilterView.filter_select(:user, :name, params))

    input_name_expected =
      "<input id=\"user_name_equals\" name=\"user[name_equals]\" type=\"text\" value=\"Skywalker\">"

    assert input_name_expected ==
             safe_to_string(Torch.FilterView.filter_string_input(:user, :name, params))

    input_email_expected =
      "<input id=\"user_email_contains\" name=\"user[email_contains]\" type=\"text\">"

    assert input_email_expected ==
             safe_to_string(Torch.FilterView.filter_string_input(:user, :email, params))
  end

  test "param name does not greedily match" do
    # * See GitHub PR 372: https://github.com/mojotech/torch/pull/372

    params = %{
      "filters" => [
        "robot[board_serial_contains]",
        "robot[serial_contains]",
        "robot[other_serial_contains]"
      ],
      "robot" => %{
        "board_serial_contains" => "0987654321",
        "serial_contains" => "1234567890",
        "other_serial_contains" => "qwertyuiop"
      }
    }

    expected =
      "<input id=\"robot_board_serial_contains\" name=\"robot[board_serial_contains]\" type=\"text\" value=\"0987654321\">"

    assert expected ==
             safe_to_string(Torch.FilterView.filter_string_input(:robot, :board_serial, params))

    expected =
      "<input id=\"robot_serial_contains\" name=\"robot[serial_contains]\" type=\"text\" value=\"1234567890\">"

    assert expected ==
             safe_to_string(Torch.FilterView.filter_string_input(:robot, :serial, params))

    expected =
      "<input id=\"robot_other_serial_contains\" name=\"robot[other_serial_contains]\" type=\"text\" value=\"qwertyuiop\">"

    assert expected ==
             safe_to_string(Torch.FilterView.filter_string_input(:robot, :other_serial, params))
  end

  test "filter uuid_select option selects a uuid" do
    expected =
      "<select class=\"filter-type\" id=\"filters_\" name=\"filters[]\"><option selected value=\"post[id_equals]\">Equals</option></select>"

    assert expected == safe_to_string(Torch.FilterView.filter_uuid(:post, :id, %{}))

    uuid = "3e03842b-0bde-471b-8825-24768ef6fbc2"

    params = %{
      "filters" => [
        "post[id_equals]"
      ],
      "post" => %{
        "id_equals" => uuid
      }
    }

    expected =
      "<select class=\"filter-type\" id=\"filters_\" name=\"filters[]\"><option selected value=\"post[id_equals]\">Equals</option></select>"

    assert expected == safe_to_string(Torch.FilterView.filter_uuid(:post, :id, params))

    input_expected =
      "<input id=\"post_id_equals\" name=\"post[id_equals]\" type=\"text\" value=\"#{uuid}\">"

    assert input_expected ==
             safe_to_string(Torch.FilterView.filter_string_input(:post, :id, params))
  end
end

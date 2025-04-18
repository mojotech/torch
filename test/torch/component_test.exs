defmodule Torch.ComponentTest do
  use ExUnit.Case, async: true
  use Phoenix.Component

  import Phoenix.LiveViewTest

  import Torch.Component,
    only: [torch_input: 1, torch_label: 1, torch_error: 1, flash_messages: 1, torch_flash: 1]

  alias Torch.Component

  describe "torch_input/1" do
    test "renders a text input with default attributes" do
      html =
        render_component(fn assigns ->
          ~H"""
            <.torch_input type="text" name="username" value="test_user" />
          """
        end)

      assert html =~ ~s(<input type="text" name="username" id="username" value="test_user")
    end

    test "renders a checkbox input with checked attribute" do
      html =
        render_component(fn assigns ->
          ~H"""
            <.torch_input type="checkbox" name="accept_terms" value="true" />
          """
        end)

      assert html =~
               ~s(<input type="checkbox" name="accept_terms" id="accept_terms" value="true" checked)
    end

    test "renders a select input with options and prompt" do
      html =
        render_component(
          fn assigns ->
            ~H"""
              <.torch_input type="select" name="country" options={@options} prompt="Select a country" value="us" />
            """
          end,
          %{
            options: [{"USA", "us"}, {"Canada", "ca"}]
          }
        )

      assert html =~ ~s(<option value="">Select a country</option>)
      assert html =~ ~s(<option selected value="us">USA</option>)
      assert html =~ ~s(<option value="ca">Canada</option>)
    end

    test "renders a textarea input with value" do
      html =
        render_component(fn assigns ->
          ~H"""
            <.torch_input type="textarea" name="bio" value="This is a test bio." />
          """
        end)

      assert html =~ ~s(<textarea id="bio" name="bio" class="">\nThis is a test bio.</textarea>)
    end

    test "renders errors for invalid input" do
      html =
        render_component(
          fn assigns ->
            ~H"""
              <.torch_input type="text" name="username" value="" errors={@errors} />
            """
          end,
          %{
            errors: ["can't be blank"]
          }
        )

      assert html =~ ~s(<span class="invalid-feedback">can&#39;t be blank</span>)
    end
  end

  describe "torch_label/1" do
    test "renders a label with text" do
      html =
        render_component(fn assigns ->
          ~H"""
            <.torch_label for="username">Username</.torch_label>
          """
        end)

      assert html =~ ~s(<label for="username">\n  Username\n</label>)
    end
  end

  describe "torch_error/1" do
    test "renders an error message" do
      html =
        render_component(fn assigns ->
          ~H"""
            <.torch_error for="username">This is an error.</.torch_error>
          """
        end)

      assert html =~ ~s(<span class="invalid-feedback">This is an error.</span>)
    end
  end

  describe "flash_messages/1" do
    test "renders flash messages" do
      html =
        render_component(
          fn assigns ->
            ~H"""
              <.flash_messages flash={@flash} />
            """
          end,
          %{
            flash: %{"info" => "Information message", "error" => "Error message"}
          }
        )

      assert html =~ ~s(<p class="torch-flash info">Information message)
      assert html =~ ~s(<p class="torch-flash error">Error message)
    end
  end

  describe "torch_flash/1" do
    test "renders a single flash message" do
      html =
        render_component(fn assigns ->
          ~H"""
            <.torch_flash flash_type="info" message="This is a flash message." />
          """
        end)

      assert html =~ ~s(<p class="torch-flash info">This is a flash message.)
    end
  end

  describe "translate_error/1" do
    test "translates an error message with count" do
      msg = Component.translate_error({"%{count} files", count: 2})
      assert msg == "2 files"
    end

    test "translates a simple error message" do
      msg = Component.translate_error({"is invalid", []})
      assert msg == "is invalid"
    end
  end

  describe "translate_errors/2" do
    test "translates errors for a specific field" do
      errors = [username: {"can't be blank", []}, email: {"is invalid", []}]
      translated = Component.translate_errors(errors, :username)
      assert translated == ["can't be blank"]
    end
  end
end

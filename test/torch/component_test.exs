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
    
    test "renders a string input type" do
      html =
        render_component(fn assigns ->
          ~H"""
            <.torch_input type="string" name="username" value="test_user" label="Username" />
          """
        end)

      assert html =~ ~s(<input type="text" name="username" id="username" value="test_user")
      assert html =~ ~s(<label for="username">\n  Username\n</label>)
    end
    
    test "renders a number input type" do
      html =
        render_component(fn assigns ->
          ~H"""
            <.torch_input type="number" name="age" value="25" label="Age" />
          """
        end)

      assert html =~ ~s(<input type="number" name="age" id="age" value="25")
      assert html =~ ~s(<label for="age">\n  Age\n</label>)
    end
    
    test "renders a date input type" do
      html =
        render_component(fn assigns ->
          ~H"""
            <.torch_input type="date" name="birthday" value="2023-01-01" label="Birthday" />
          """
        end)

      assert html =~ ~s(<input type="date" name="birthday" id="birthday" value="2023-01-01")
      assert html =~ ~s(<label for="birthday">\n  Birthday\n</label>)
    end
    
    test "renders with custom id" do
      html =
        render_component(fn assigns ->
          ~H"""
            <.torch_input type="text" name="username" id="custom-id" value="test_user" />
          """
        end)

      assert html =~ ~s(<input type="text" name="username" id="custom-id" value="test_user")
    end
    
    test "renders with form field" do
      form_data = %{
        "user" => %{
          "name" => "John Doe",
          "email" => "john@example.com"
        }
      }
      
      form = Phoenix.Component.to_form(form_data, as: :user)
      field = Phoenix.HTML.FormField.to_form_field(form, :name)
      
      html =
        render_component(
          fn assigns ->
            ~H"""
              <.torch_input field={@field} type="text" label="Name" />
            """
          end,
          %{
            field: field
          }
        )

      assert html =~ ~s(<input type="text" name="user[name]" id="user_name" value="John Doe")
      assert html =~ ~s(<label for="user_name">\n  Name\n</label>)
    end
    
    test "renders with form field and multiple flag" do
      form_data = %{
        "user" => %{
          "roles" => ["admin", "editor"]
        }
      }
      
      form = Phoenix.Component.to_form(form_data, as: :user)
      field = Phoenix.HTML.FormField.to_form_field(form, :roles)
      
      html =
        render_component(
          fn assigns ->
            ~H"""
              <.torch_input field={@field} type="select" multiple={true} options={@options} label="Roles" />
            """
          end,
          %{
            field: field,
            options: [{"Admin", "admin"}, {"Editor", "editor"}, {"Viewer", "viewer"}]
          }
        )

      assert html =~ ~s(<select id="user_roles" name="user[roles][]" class="" multiple)
      assert html =~ ~s(<option selected value="admin">Admin</option>)
      assert html =~ ~s(<option selected value="editor">Editor</option>)
      assert html =~ ~s(<option value="viewer">Viewer</option>)
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
    
    test "renders empty flash messages" do
      html =
        render_component(
          fn assigns ->
            ~H"""
              <.flash_messages flash={@flash} />
            """
          end,
          %{
            flash: %{}
          }
        )

      assert html =~ ~s(<section id="torch-flash-messages">)
      assert html =~ ~s(<div class="torch-container">)
      refute html =~ ~s(<p class="torch-flash)
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
    
    test "renders a flash message with close button" do
      html =
        render_component(fn assigns ->
          ~H"""
            <.torch_flash flash_type="error" message="Error occurred." />
          """
        end)

      assert html =~ ~s(<p class="torch-flash error">Error occurred.)
      assert html =~ ~s(<button class="torch-flash-close">x</button>)
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
    
    test "returns empty list when field has no errors" do
      errors = [username: {"can't be blank", []}, email: {"is invalid", []}]
      translated = Component.translate_errors(errors, :password)
      assert translated == []
    end
  end
end

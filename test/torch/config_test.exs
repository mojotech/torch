defmodule Torch.ConfigTest do
  use ExUnit.Case, async: true

  describe "otp_app/0" do
    test "returns the configured otp_app" do
      # Save the original value
      original_value = Application.get_env(:torch, :otp_app)

      # Set a test value
      Application.put_env(:torch, :otp_app, :test_app)
      assert Torch.Config.otp_app() == :test_app

      # Restore the original value
      if original_value do
        Application.put_env(:torch, :otp_app, original_value)
      else
        Application.delete_env(:torch, :otp_app)
      end
    end

    test "returns nil when otp_app is not configured" do
      # Save the original value
      original_value = Application.get_env(:torch, :otp_app)

      # Delete the config
      Application.delete_env(:torch, :otp_app)
      assert Torch.Config.otp_app() == nil

      # Restore the original value
      if original_value do
        Application.put_env(:torch, :otp_app, original_value)
      end
    end
  end

  describe "i18n_backend/0" do
    test "returns the configured i18n_backend" do
      # Save the original value
      original_value = Application.get_env(:torch, :i18n_backend)

      # Set a test value
      test_backend = Module.concat(["Test", "I18n", "Backend"])
      Application.put_env(:torch, :i18n_backend, test_backend)
      assert Torch.Config.i18n_backend() == test_backend

      # Restore the original value
      if original_value do
        Application.put_env(:torch, :i18n_backend, original_value)
      else
        Application.delete_env(:torch, :i18n_backend)
      end
    end

    test "returns default backend when i18n_backend is not configured" do
      # Save the original value
      original_value = Application.get_env(:torch, :i18n_backend)

      # Delete the config
      Application.delete_env(:torch, :i18n_backend)
      assert Torch.Config.i18n_backend() == Torch.I18n.Backend

      # Restore the original value
      if original_value do
        Application.put_env(:torch, :i18n_backend, original_value)
      end
    end
  end
end


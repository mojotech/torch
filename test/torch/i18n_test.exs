defmodule Torch.I18nTest do
  use ExUnit.Case

  defmodule CustomI18nBackend do
    def message("Contains"), do: "** CUSTOMIZED **"
    def message(t), do: Torch.I18n.Backend.message(t)
  end

  setup_all do
    on_exit(fn ->
      Application.put_env(:torch, :i18n_backend, Torch.I18n.Backend)
    end)

    [i18n_backend: Torch.Config.i18n_backend()]
  end

  test "uses a default backend if none configured", context do
    Application.put_env(:torch, :i18n_backend, context[:i18n_backend])

    assert Torch.I18n.Backend == Torch.Config.i18n_backend()
    assert "Contains" == Torch.I18n.message("Contains")
  end

  test "allows a custom backend to be defined" do
    Application.put_env(:torch, :i18n_backend, CustomI18nBackend)

    assert CustomI18nBackend == Torch.Config.i18n_backend()
    assert "** CUSTOMIZED **" == Torch.I18n.message("Contains")
    assert "Equals" == Torch.I18n.message("Equals")
  end
end

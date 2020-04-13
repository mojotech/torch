defmodule Torch.I18n do
  @moduledoc """
  Provides internationalization support for Torch apps using standard
  Gettext features as a default, but also allows Torch users to customize
  their own "messaging backends" for custom i18n support.
  """

  def message(text_key), do: Torch.Config.i18n_backend().message(text_key)
end

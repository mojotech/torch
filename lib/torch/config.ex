defmodule Torch.Config do
  @moduledoc """
  Application config for torch.
  """

  def otp_app do
    Application.get_env(:torch, :otp_app)
  end

  def i18n_backend do
    Application.get_env(:torch, :i18n_backend, Torch.I18n.Backend)
  end
end

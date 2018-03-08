defmodule Torch.Config do
  @moduledoc """
  Application config for torch.
  """

  def otp_app do
    Application.get_env(:torch, :otp_app) || raise "Torch :otp_app config not set!"
  end

  def template_format do
    Application.get_env(:torch, :template_format) ||
      raise "Torch :template_format config not set!"
  end
end
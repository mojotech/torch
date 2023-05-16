defmodule Torch.PageView do
  @moduledoc deprecated: "This module will be fully removed in Torch 6.0"
  @doc """
  DEPRECATED: Use Torch.Helpers.body_classes/1 instead

  Takes the controller action name and appends it to the torch- prefix.

  ## Example

      iex> body_classes(%Plug.Conn{private: %{phoenix_action: :create}})
      "torch-create"

      iex> body_classes(%Plug.Conn{private: %{phoenix_action: :custom_action}})
      "torch-custom-action"
  """

  @spec body_classes(Plug.Conn.t()) :: String.t()
  @deprecated "Use Torch.Helpers.body_classes/1 instead"
  def body_classes(conn), do: Torch.Helpers.body_classes(conn)
end

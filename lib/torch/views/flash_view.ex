defmodule Torch.FlashView do
  @moduledoc """
  Contains functions for dealing with flash messages.
  """
  @moduledoc deprecated: "This module will be fully removed in Torch 6.0"

  use Phoenix.Component

  @doc """
  DEPRECATED: Use Torch.Components.flash_messages/1 component instead

  Returns a formatted group of all flash messages available.

  ## Parameters

  - `assigns`: The current `Plug.Conn.assigns` map.

  ## Example

      iex> conn = %Plug.Conn{assigns: %{flash: %{"error" => "Error Message", "info" => "Info Message", "custom" => "Custom flash key"}}}
      ...> flash_messages(conn.assigns) |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary()
      "<section id=\\"torch-flash-messages\\">\\n  <div class=\\"torch-container\\">\\n    <p class=\\"torch-flash custom\\">Custom flash key&nbsp;<button class=\\"torch-flash-close\\">x</button></p><p class=\\"torch-flash error\\">Error Message&nbsp;<button class=\\"torch-flash-close\\">x</button></p><p class=\\"torch-flash info\\">Info Message&nbsp;<button class=\\"torch-flash-close\\">x</button></p>\\n  </div>\\n</section>"
  """
  @spec flash_messages(%{assigns: %{flash: map}}) :: Phoenix.LiveView.Rendered.t()
  @deprecated "Use Torch.Components.flash_messages/1 instead"
  def flash_messages(assigns), do: Torch.Component.flash_messages(assigns)
end

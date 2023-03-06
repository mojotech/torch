defmodule Torch.FlashView do
  @moduledoc """
  Contains functions for dealing with flash messages.
  """

  use Phoenix.Component

  @doc """
  Returns a formatted group of all flash messages available.

  ## Parameters

  - `assigns`: The current `Plug.Conn.assigns` map.

  ## Example

      iex> conn = %Plug.Conn{assigns: %{flash: %{"error" => "Error Message", "info" => "Info Message", "invalid" => "Invalid flash key"}}}
      ...> flash_messages(conn.assigns) |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary()
      "<section id=\\"torch-flash-messages\\">\\n  <div class=\\"torch-container\\">\\n    <p class=\\"torch-flash error\\">Error Message&nbsp;<button class=\\"torch-flash-close\\">x</button></p>\\n    <p class=\\"torch-flash info\\">Info Message&nbsp;<button class=\\"torch-flash-close\\">x</button></p>\\n    \\n  </div>\\n</section>"
  """
  @spec flash_messages(%{assigns: %{flash: map}}) :: Phoenix.LiveView.Rendered.t()
  def flash_messages(assigns) do
    ~H"""
    <section id="torch-flash-messages">
      <div class="torch-container">
        <%= flash_message assigns, :error %>
        <%= flash_message assigns, :info %>
        <%= flash_message assigns, :success %>
      </div>
    </section>
    """
  end

  @doc """
  Returns a formatted flash message of the given type.

  ## Parameters

  - `assigns`: The current `Plug.Conn.assigns` map.
  - `type`: The flash type, such as `:error`.

  ## Example

      iex> conn = %Plug.Conn{assigns: %{flash: %{"error" => "Error Message"}}}
      ...> flash_message(conn.assigns, "error") |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary()
      "<p class=\\"torch-flash error\\">Error Message&nbsp;<button class=\\"torch-flash-close\\">x</button></p>"
  """
  @spec flash_message(%{assigns: %{flash: map}}, type :: atom | String.t()) :: Phoenix.HTML.safe()
  def flash_message(assigns, type) do
    message = Phoenix.Flash.get(assigns[:flash] || %{}, type)

    if message do
      torch_flash(%{message: message, flash_type: type})
    end
  end

  def torch_flash(assigns) do
    ~H"""
    <p class={"torch-flash #{@flash_type}"}><%= @message %>&nbsp;<button class="torch-flash-close">x</button></p>
    """
  end
end

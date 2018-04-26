defmodule Torch.FlashView do
  @moduledoc """
  Contains functions for dealing with flash messages.
  """

  use Phoenix.View, root: "lib/torch/templates"
  use Phoenix.HTML

  import Phoenix.Controller, only: [get_flash: 2]

  @doc """
  Returns a formatted flash message of the given type.

  ## Parameters

  - `conn`: The current `Plug.Conn`.
  - `type`: The flash type, such as `:error`.

  ## Example

      iex> conn = %Plug.Conn{private: %{phoenix_flash: %{"error" => "Error Message"}}}
      ...> flash_message(conn, "error") |> safe_to_string()
      "<p class=\\"torch-flash error\\">Error Message <button class='torch-flash-close'>x</button></p>"
  """
  @spec flash_message(Plug.Conn.t(), type :: atom | String.t()) :: Phoenix.HTML.safe()
  def flash_message(conn, type) do
    message = get_flash(conn, type)

    if message do
      content_tag :p, class: "torch-flash #{type}" do
        raw("#{message} <button class='torch-flash-close'>x</button>")
      end
    end
  end
end

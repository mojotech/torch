defmodule Torch.PageView do
  @doc """
  Takes the controller action name and appends it to the torch- prefix.

  ## Example

      iex> body_classes(%Plug.Conn{private: %{phoenix_action: :create}})
      "torch-create"
  """
  @spec body_classes(Plug.Conn.t()) :: String.t()
  def body_classes(conn) do
    "torch-#{action_name(conn)}"
    |> String.trim()
  end

  defp action_name(conn) do
    conn
    |> Phoenix.Controller.action_name()
    |> Atom.to_string()
    |> String.replace("_", "-")
  end
end

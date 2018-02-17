defmodule Torch.PageView do
  @doc """
  Takes the controller action name and
  appends it to the torch- prefix.
  """
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
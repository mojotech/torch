defmodule Torch.AssetsController do
  @moduledoc false

  use Phoenix.Controller

  def assets(conn, %{"file_name" => name}) do
    text(conn, File.read("./priv/static/#{name}"))
  end
end
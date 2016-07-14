defmodule Mix.Tasks.Regenerate do
  @moduledoc """
  Regenerates the Post and Author code using the Torch generators.

  ## Example

      mix regenerate
  """

  use Mix.Task

  def run(_args) do
    File.rm_rf!("web/templates/admin/")
    File.rm_rf!("web/controllers/admin/")
    File.rm_rf!("web/views/admin/")
    Mix.Task.run "torch.gen.html", ~w(Admin Post posts title:string body:text draft:boolean inserted_at:date updated_at:date)
    Mix.Task.reenable("torch.gen.html")
    Mix.Task.run "torch.gen.html", ~w(Admin Author authors name:string email:string inserted_at:date updated_at:date)
  end
end

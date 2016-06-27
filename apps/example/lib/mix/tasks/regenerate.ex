defmodule Mix.Tasks.Regenerate do
  @moduledoc """
  Regenerates the Post and Author code using the Torch generators.

  ## Example

      mix regenerate
  """

  def run(_args) do
    File.rm_rf!("web/templates/admin/")
    File.rm_rf!("web/controllers/admin/")
    File.rm_rf!("web/views/admin/")
    Mix.Task.run "torch.gen.html", ~w(Admin Post posts title:string body:text inserted_at:date updated_at:date)
    Mix.Task.reenable("torch.gen.html")
    Mix.Task.run "torch.gen.html", ~w(Admin Author authors name:string email:string inserted_at:date updated_at:date)
  end
end

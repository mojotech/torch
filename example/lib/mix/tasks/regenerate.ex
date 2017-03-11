defmodule Mix.Tasks.Regenerate do
  @moduledoc """
  Regenerates the Post and Author code using the Torch generators.

  ## Example

      mix regenerate
  """

  use Mix.Task

  def run([format]) do
    File.rm_rf!("web/templates/admin/")
    File.rm_rf!("web/controllers/admin/")
    File.rm_rf!("web/views/admin/")
    Mix.Task.run "torch.gen", ~w(#{format} Admin Post posts title:string body:text draft:boolean inserted_at:date updated_at:date category_id:references:category,categories:id,name author_id:references:author,authors:id,name)
    Mix.Task.reenable("torch.gen")
    Mix.Task.run "torch.gen", ~w(#{format} Admin Author authors name:string email:string inserted_at:date updated_at:date)
    Mix.Task.reenable("torch.gen")
    Mix.Task.run "torch.gen", ~w(#{format} Admin Category categories name:string)
  end
end

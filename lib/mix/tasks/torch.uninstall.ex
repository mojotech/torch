defmodule Mix.Tasks.Torch.Uninstall do
  @moduledoc """
  Uninstalls torch layout & templates.

  ## Example

      mix torch.uninstall
  """

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise("mix torch.uninstall can only be run inside an application directory")
    end

    %{format: format, otp_app: otp_app} = Mix.Torch.parse_config!("torch.uninstall", args)

    paths = [
      "priv/templates/phx.gen.html/controller_test.exs",
      "priv/templates/phx.gen.html/controller.ex",
      "priv/templates/phx.gen.html/edit.html.#{format}",
      "priv/templates/phx.gen.html/form.html.#{format}",
      "priv/templates/phx.gen.html/index.html.#{format}",
      "priv/templates/phx.gen.html/new.html.#{format}",
      "priv/templates/phx.gen.html/show.html.#{format}",
      "priv/templates/phx.gen.html/view.ex",
      "priv/templates/phx.gen.context/access_no_schema.ex",
      "priv/templates/phx.gen.context/context.ex",
      "priv/templates/phx.gen.context/schema_access.ex",
      "priv/templates/phx.gen.context/test_cases.exs",
      "priv/templates/phx.gen.context/context_test.exs",
      "lib/#{otp_app}_web/templates/layout/torch_layout.html.#{format}"
    ]

    Enum.each(paths, &File.rm/1)
  end
end

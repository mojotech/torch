defmodule Mix.Tasks.Torch.UninstallTest do
  use Torch.MixCase

  setup_all :prepare_example_apps

  describe ".run/1" do
    setup :clean_generated_files

    test_mix_config_errors("torch.uninstall")

    @tag :integration
    test "removes all torch files from regular project if they exist" do
      for format <- @formats do
        System.cmd("mix", ["torch.install", "--format", "#{format}"], cd: @project_dir)
        System.cmd("mix", ["torch.uninstall", "--format", "#{format}"], cd: @project_dir)

        refute File.exists?("#{@project_dir}/priv/templates/phx.gen.html/")

        refute File.exists?(
                 "#{@project_dir}/lib/example_web/templates/layout/torch.html.#{format}"
               )
      end
    end

    # TODO: add test for umbrella project
  end
end

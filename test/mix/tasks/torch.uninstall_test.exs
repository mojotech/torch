defmodule Mix.Tasks.Torch.UninstallTest do
  use Torch.MixCase

  describe ".run/1" do
    test_mix_config_errors("torch.uninstall")

    Mix.Task.rerun("torch.install", ["--app", "my_app"])
    Mix.Task.rerun("torch.uninstall", ["--app", "my_app"])

    # TODO: add test for umbrella project
  end
end

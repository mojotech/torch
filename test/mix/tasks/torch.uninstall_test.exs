defmodule Mix.Tasks.Torch.UninstallTest do
  use Torch.MixCase

  describe ".run/1" do
    test_mix_config_errors("torch.uninstall")

    # TODO: add test for umbrella project
  end
end

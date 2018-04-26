defmodule Mix.Tasks.Torch.InstallTest do
  use Torch.MixCase

  describe ".run/1" do
    test_mix_config_errors("torch.install")

    # TODO: add test for umbrella project
  end
end

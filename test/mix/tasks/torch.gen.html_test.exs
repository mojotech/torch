defmodule Mix.Tasks.Torch.Gen.HtmlTest do
  use Torch.MixCase, async: false

  describe ".run/1" do
    test_mix_config_errors("torch.gen.html")

    # TODO: Add integration test for umbrella app
  end
end

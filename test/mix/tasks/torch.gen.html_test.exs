defmodule Mix.Tasks.Torch.Gen.HtmlTest do
  use Torch.MixCase, async: false

  describe ".run/1" do
    setup [:prepare_example_apps, :clean_generated_files]

    test_mix_config_errors("torch.gen.html")

    @tag :integration
    test "generates valid context, controllers, and tests" do
      # Install torch layout
      System.cmd("mix", ["torch.install"], cd: @project_dir)

      # TODO: support slim
      for format <- [:eex] do
        System.cmd(
          "mix",
          ["torch.gen.html", "Blog", "Post", "posts", "title:string", "--format", "#{format}"],
          cd: @project_dir
        )

        # Overwrite the router to include the generated link as
        # shown in the instructions
        File.write!(
          "#{@project_dir}/lib/example_web/router.ex",
          File.read!("test/support/routers/modified.ex")
        )

        # Run tests in the example app, ensure they are passing
        assert {response, status} = System.cmd("mix", ["test"], cd: @project_dir)
        assert status == 0, response
        assert response =~ "20 tests, 0 failures"

        # Clean up generated files so they don't get committed by accident
        clean_generated_files([])
      end
    end

    # TODO: Add integration test for umbrella app
  end
end

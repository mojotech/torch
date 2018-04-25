defmodule Mix.Tasks.Torch.InstallTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  @project_dir "test/support/apps/example"
  @formats [:eex, :slim]

  defp prepare_example_apps(_) do
    capture_io(fn ->
      System.cmd("mix", ["deps.get"], cd: @project_dir)
    end)

    :ok
  end

  defp clean_generated_files(_) do
    for format <- @formats do
      File.rm("#{@project_dir}/lib/example_web/templates/layout/torch.html.#{format}")
    end

    :ok
  end

  setup_all :prepare_example_apps

  describe ".run/1" do
    setup :clean_generated_files

    test "raises error if :format not specified" do
      assert_raise Mix.Error,
                   """
                   Template format is invalid: nil. Either configure it as
                   shown below or pass it via the `--format` option.

                       config :torch,
                         template_format: :slim

                       # Alternatively
                       mix torch.install --format slim

                   Supported formats: eex, slim
                   """,
                   fn ->
                     Mix.Task.rerun("torch.install", ["--app", "my_app"])
                   end
    end

    test "raises error if format is invalid" do
      assert_raise Mix.Error, fn ->
        Mix.Task.rerun("torch.install", ["--app", "my_app", "--format", "invalid"])
      end
    end

    test "raises error if :otp_app not specified" do
      assert_raise Mix.Error,
                   """
                   You need to specify an OTP app to generate files within. Either
                   configure it as shown below or pass it in via the `--app` option.

                       config :torch,
                         otp_app: :my_app

                       # Alternatively
                       mix torch.install --app my_app
                   """,
                   fn ->
                     Mix.Task.rerun("torch.install", ["--format", "eex"])
                   end
    end

    @tag :integration
    test "injects layout template into regular project" do
      for format <- @formats do
        System.cmd("mix", ["torch.install", "--format", "#{format}"], cd: @project_dir)

        assert File.exists?(
                 "#{@project_dir}/lib/example_web/templates/layout/torch.html.#{format}"
               )
      end
    end

    # TODO: add test for umbrella project
  end
end

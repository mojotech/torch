defmodule Torch.MixCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      import Torch.MixCase

      @project_dir "test/support/apps/example"
      @formats [:eex, :slim]
    end
  end

  import ExUnit.CaptureIO

  @project_dir "test/support/apps/example"
  @formats [:eex, :slim]

  @doc false
  def prepare_example_apps(_) do
    capture_io(fn ->
      System.cmd("mix", ["deps.get"], cd: @project_dir)
    end)

    :ok
  end

  @doc false
  def clean_generated_files(_) do
    for format <- @formats do
      File.rm("#{@project_dir}/lib/example_web/templates/layout/torch.html.#{format}")
    end

    :ok
  end

  @doc false
  # Generates tests on the given mix task to ensure it handles errors properly
  defmacro test_mix_config_errors(task) do
    quote do
      test "raises error if :format not specified" do
        assert_raise Mix.Error,
                     """
                     Template format is invalid: nil. Either configure it as
                     shown below or pass it via the `--format` option.

                         config :torch,
                           template_format: :slim

                         # Alternatively
                         mix #{unquote(task)} --format slim

                     Supported formats: eex, slim
                     """,
                     fn ->
                       Mix.Task.rerun(unquote(task), ["--app", "my_app"])
                     end
      end

      test "raises error if format is invalid" do
        assert_raise Mix.Error, fn ->
          Mix.Task.rerun(unquote(task), ["--app", "my_app", "--format", "invalid"])
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
                         mix #{unquote(task)} --app my_app
                     """,
                     fn ->
                       Mix.Task.rerun(unquote(task), ["--format", "eex"])
                     end
      end
    end
  end
end

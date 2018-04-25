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

  @project_dir "test/support/apps/example"
  @formats [:eex, :slim]

  @doc false
  def prepare_example_apps(_) do
    System.cmd("mix", ["deps.get"], cd: @project_dir)
    System.cmd("mix", ["ecto.drop"], cd: @project_dir, env: [{"MIX_ENV", "test"}])

    :ok
  end

  @doc false
  def clean_generated_files(_) do
    for format <- @formats do
      files = [
        "#{@project_dir}/priv/templates/",
        "#{@project_dir}/priv/repo/migrations/",
        "#{@project_dir}/lib/example/blog/",
        "#{@project_dir}/test/example/blog/",
        "#{@project_dir}/lib/example_web/controllers/post_controller.ex",
        "#{@project_dir}/lib/example_web/templates/layout/torch.html.#{format}",
        "#{@project_dir}/lib/example_web/templates/post/",
        "#{@project_dir}/lib/example_web/views/post_view.ex",
        "#{@project_dir}/test/example_web/controllers/post_controller_test.exs"
      ]

      Enum.each(files, &File.rm_rf/1)

      File.write!(
        "#{@project_dir}/lib/example_web/router.ex",
        File.read!("test/support/routers/original.ex")
      )

      File.mkdir("#{@project_dir}/priv/repo/migrations/")
    end

    :ok
  end

  @doc false
  # Generates tests on the given mix task to ensure it handles errors properly
  defmacro test_mix_config_errors(task) do
    quote location: :keep do
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

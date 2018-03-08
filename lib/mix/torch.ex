defmodule Mix.Torch do
  @moduledoc false

  @doc """
  Copies files from source dir to target dir
  according to the given map.

  Files are evaluated against EEx according to
  the given binding.
  """
  def copy_from(apps, source_dir, target_dir, _binding, mapping) when is_list(mapping) do
    roots = Enum.map(apps, &to_app_source(&1, source_dir))

    for {_format, source_file_path, target_file_path} <- mapping do
      source =
        Enum.find_value(roots, fn root ->
          source = Path.join(root, source_file_path)
          if File.exists?(source), do: source
        end) || raise "could not find #{source_file_path} in any of the sources"

      target = Path.join(target_dir, target_file_path)

      contents = File.read!(source)
      # case format do
      #   :eex  -> EEx.eval_file(source, binding)
      #   _ -> File.read!(source)
      # end

      Mix.Generator.create_file(target, contents)
    end
  end

  defp to_app_source(path, source_dir) when is_binary(path), do: Path.join(path, source_dir)
  defp to_app_source(app, source_dir) when is_atom(app), do: Application.app_dir(app, source_dir)
end
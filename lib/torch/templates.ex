defmodule Torch.Templates do
  @moduledoc """
  Module allowing to automatically manage templates depending of the given mix task
  """

  @template_path "priv/templates"

  def inject_templates(mix_task, options) do
    out_directory = Keyword.get(options, :out_directory, "#{@template_path}/#{mix_task}")

    with templates <- get_templates(mix_task, Application.spec(:phoenix, :vsn), options) do
      for {source_filename, target_filename, template_path} <- templates do
        source_file_path = get_source_file_path(mix_task, template_path, source_filename)
        target_file_path = get_target_file_path(out_directory, target_filename)

        Mix.Generator.create_file(target_file_path, File.read!(source_file_path))
      end
    end
  end

  def backup_project_templates(mix_task) do
    File.rename("#{@template_path}/#{mix_task}", "#{@template_path}/#{mix_task}_backup")
  end

  def restore_project_templates(mix_task) do
    File.rename("#{@template_path}/#{mix_task}_backup", "#{@template_path}/#{mix_task}")
  end

  def remove_templates(mix_task) do
    File.rm_rf("#{@template_path}/#{mix_task}/")
  end

  def get_template_path(mix_task) do
    [Application.app_dir(:torch), @template_path, mix_task]
    |> Path.join()
  end

  defp get_target_file_path(out_directory, filename) do
    [out_directory, filename]
    |> Path.join()
  end

  defp get_source_file_path(mix_task, template_path, filename) do
    filename = if template_path == nil do
      filename
    else
      [template_path, filename]
      |> Path.join()
    end

    [get_template_path(mix_task), filename]
    |> Path.join()
  end

  @spec get_templates(
          String.t(),
          String.t() | List.t()
        ) :: [String.t()] | nil
  def get_templates(mix_task, phoenix_version),
      do: get_templates(mix_task, phoenix_version, [])

  @doc """
  Allow to get templates for a given mix command

  ## Available options

    format: `String.t()` default to "eex"
    template_path: `String.t()` defaults to result of `get_template_path/1`

  ## Examples

      iex> Torch.Templates.get_templates("some-task", "some-phoenix-version")
      nil

      iex> Torch.Templates.get_templates("phx.gen.html", "1.4.0")
      [
        {"controller.ex", "controller.ex", nil},
        {"controller_test.exs", "controller_test.exs", nil},
        {"edit.html.eex", "edit.html.eex", "eex"},
        {"form.html.eex", "form.html.eex", "eex"},
        {"index.html.eex", "index.html.eex", "eex"},
        {"new.html.eex", "new.html.eex", "eex"},
        {"show.html.eex", "show.html.eex", "eex"},
        {"view.ex", "view.ex", nil}
      ]

      iex> Torch.Templates.get_templates("phx.gen.html", "1.5.0")
      [
        {"controller.phx1_5_0.ex", "controller.ex", nil},
        {"controller_test.exs", "controller_test.exs", nil},
        {"edit.html.eex", "edit.html.eex", "eex"},
        {"form.html.eex", "form.html.eex", "eex"},
        {"index.html.eex", "index.html.eex", "eex"},
        {"new.html.eex", "new.html.eex", "eex"},
        {"show.html.eex", "show.html.eex", "eex"},
        {"view.ex", "view.ex", nil}
      ]

      iex> Torch.Templates.get_templates("torch.install", "1.4.0", format: "slim", suffixe: "torch_")
      [
        {"layout.html.slim", "torch_layout.html.slim", "slim"}
      ]

      iex> Torch.Templates.get_templates("torch.install", "1.5.0", suffixe: "torch_")
      [
        {"layout.phx1_5_0.html.eex", "torch_layout.html.eex", "eex"}
      ]

  """
  @spec get_templates(
          String.t(),
          String.t() | List.t(),
          Keyword.t()
        ) :: [String.t()] | nil
  def get_templates(mix_task, phoenix_version, options) when is_list(phoenix_version),
      do: get_templates(mix_task, to_string(phoenix_version), options)

  def get_templates(mix_task, phoenix_version, options) when is_binary(phoenix_version) do
    format = Keyword.get(options, :format, "eex")
    suffixe = Keyword.get(options, :suffixe)
    template_path = Keyword.get(options, :template_path, get_template_path(mix_task))
    case list_templates_dir(template_path) do
      {:ok, templates} ->
        templates
        |> templates_to_map()
        |> exclude_invalid_templates()
        |> order_templates()
        |> valid_template_format(format)
        |> valid_template_version(phoenix_version)
        |> normalize_templates(suffixe)

      _ -> nil
    end
  end

  defp list_templates_dir(dir, template \\ nil) do
    case File.ls(dir) do
      {:ok, files} ->
        {
          :ok,
          files
          |> Enum.map(
               fn filename ->
                 cond do
                   File.dir?("#{dir}/#{filename}") ->
                     {:ok, inner_files} = list_templates_dir("#{dir}/#{filename}", filename)
                     inner_files

                   File.regular?("#{dir}/#{filename}") ->
                     filename_to_template(dir, filename, template)

                   true -> nil
                 end
               end
             )
        }
      _ -> nil
    end
  end

  defp filename_to_template(_dir, filename, template) do
    case Regex.named_captures(~r/(?<name>.*)\.phx(?<phoenix_version>[0-9_]*)\.(?<ext>.*)/, filename) do
      %{"name" => name, "phoenix_version" => phoenix_version, "ext" => ext} ->
        phoenix_version = ">= #{String.replace(phoenix_version, "_", ".")}"
        %{name: name, file: filename, phoenix_version: phoenix_version, template: template, ext: ext}

      _ ->
        s = String.split(filename, ".")
        {name, s} = List.pop_at(s, 0)
        ext = Enum.join(s, ".")
        %{name: name, file: filename, phoenix_version: nil, template: template, ext: ext}
    end
  end

  defp templates_to_map(templates, acc \\ %{}) do
    case templates do
      templates when is_list(templates) ->
        templates
        |> Enum.reduce(acc, fn e, new_acc -> templates_to_map(e, new_acc) end)
      %{name: name} = e ->
        Map.put(
          acc,
          name,
          Map.get(acc, name, []) ++ [e]
        )
    end
  end

  defp exclude_invalid_templates(templates) do
    templates
    |> Enum.reduce(
         %{},
         fn {k, v}, acc ->
           if String.starts_with?(k, "_") == false do
             Map.put(acc, k, v)
           else
             acc
           end
         end
       )
    |> Map.new()
  end

  defp order_templates(templates) do
    templates
    |> Enum.map(fn {k, v} -> {k, Enum.sort(v, &templates_sorter/2)} end)
    |> Map.new()
  end

  defp templates_sorter(%{phoenix_version: v1}, %{phoenix_version: v2}) do
    cond do
      v1 == nil -> false
      v2 == nil -> true
      true -> v1 <= v2
    end
  end

  defp valid_template_format(%{} = templates, template_format, fallback_format \\ "eex") do
    templates
    |> Enum.map(
         fn {k, v} ->
           good_v = Enum.filter(v, fn t -> t.template == template_format end)
           fallback_v = Enum.filter(v, fn t -> t.template == fallback_format or t.template == nil end)

           if Enum.empty?(good_v) do
             {k, fallback_v}
           else
             {k, good_v}
           end
         end
       )
    |> Map.new()
  end

  defp valid_template_version(%{} = templates, phoenix_version) do
    templates
    |> Enum.map(fn {k, v} -> {k, valid_template_version(v, phoenix_version)} end)
    |> Map.new()
  end

  defp valid_template_version([%{phoenix_version: asked_version} = template | tail], phoenix_version) do
    if asked_version == nil do
      template
    else
      if Version.match?(phoenix_version, asked_version, allow_pre: true) do
        template
      else
        valid_template_version(tail, phoenix_version)
      end
    end
  end

  defp valid_template_version([template], _phoenix_version) do
    template
  end

  defp normalize_templates(templates, suffixe)  do
    templates
    |> Enum.map(
         fn {k, v} ->
           if suffixe do
             {v.file, "#{suffixe}#{k}.#{v.ext}", v.template}
           else
             {v.file, "#{k}.#{v.ext}", v.template}
           end
         end
       )
  end
end

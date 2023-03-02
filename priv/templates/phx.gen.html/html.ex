defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>HTML do
  use <%= inspect context.web_module %>, :html

  use Phoenix.HTML
  use Phoenix.View, root: "./<%= schema.singular %>_html/"

  import Torch.TableView
  import Torch.FilterView

  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, translate_error(error),
        class: "invalid-feedback",
        phx_feedback_for: input_name(form, field)
      )
    end)
  end

  embed_templates "<%= schema.singular %>_html/*"
end

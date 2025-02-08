defmodule Torch.Component do
  @moduledoc """
  Provides Phoenix.Components for use in Torch views and layouts
  """
  @moduledoc since: "5.0.0"

  use Phoenix.Component

  @doc """
  Renders a Torch form input with label and error messages.

  A `%Phoenix.HTML.Form{}` (see `Phoenix.HTML.Form`) and field name may be
  passed to the input to build input names and error messages, or all the
  attributes and errors may be passed explicitly.

  ## Examples

      <.torch_input field={@form[:email]} type="email" />
      <.torch_input name="my-input" errors={["oh no!"]} />
  """
  attr(:id, :any, default: nil)

  attr(:type, :string,
    default: "text",
    values: ~w(number checkbox textarea date datetime time datetime-local select text string file)
  )

  attr(:value, :any)
  attr(:name, :any)
  attr(:label, :string, default: nil)

  attr(:field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"
  )

  attr(:errors, :list, default: [])
  attr(:checked, :boolean, doc: "the checked flag for checkbox inputs")
  attr(:prompt, :string, default: nil, doc: "the prompt for select inputs")
  attr(:options, :list, doc: "the options to pass to `Phoenix.HTML.Form.options_for_select/2`")
  attr(:multiple, :boolean, default: false, doc: "the multiple flag for select inputs")

  attr(:rest, :global,
    include:
      ~w(autocomplete cols disabled form max maxlength min minlength pattern placeholder readonly required rows size step)
  )

  slot(:inner_block)

  def torch_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> torch_input()
  end

  def torch_input(%{type: "checkbox", value: value} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn -> Phoenix.HTML.Form.normalize_value("checkbox", value) end)

    ~H"""
    <div class="torch-form-group">
      <.torch_label for={@id}><%= @label %></.torch_label>
      <div class="torch-form-group-input">
        <input type="hidden" name={@name} value="false" />
        <input
          type="checkbox"
          name={@name}
          id={@id || @name}
          value="true"
          checked={@checked}
          class={[@errors != [] && "form-field-error"]}
          {@rest}
        />
        <.torch_error :for={msg <- @errors}><%= msg %></.torch_error>
      </div>
    </div>
    """
  end

  def torch_input(%{type: "select"} = assigns) do
    ~H"""
    <div class="torch-form-group">
      <.torch_label for={@id}><%= @label %></.torch_label>
      <div class="torch-form-group-input">
        <select
          id={@id}
          name={@name}
          class={[@errors != [] && "form-field-error"]}
          multiple={@multiple}
          {@rest}
        >
          <option :if={@prompt} value=""><%= @prompt %></option>
          <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
        </select>
        <.torch_error :for={msg <- @errors}><%= msg %></.torch_error>
      </div>
    </div>
    """
  end

  def torch_input(%{type: "textarea"} = assigns) do
    ~H"""
    <div class="torch-form-group">
      <.torch_label for={@id}><%= @label %></.torch_label>
      <div class="torch-form-group-input">
        <textarea
            id={@id || @name}
            name={@name}
            class={[@errors != [] && "form-field-error"]}
            {@rest}
        ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
        <.torch_error :for={msg <- @errors}><%= msg %></.torch_error>
      </div>
    </div>
    """
  end

  def torch_input(%{type: "string"} = assigns) do
    ~H"""
    <div class="torch-form-group">
      <.torch_label for={@id}><%= @label %></.torch_label>
      <div class="torch-form-group-input">
        <input
          type="text"
          name={@name}
          id={@id || @name}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          class={[@errors != [] && "form-field-error"]}
          {@rest}
        />
        <.torch_error :for={msg <- @errors}><%= msg %></.torch_error>
      </div>
    </div>
    """
  end

  def torch_input(assigns) do
    ~H"""
    <div class="torch-form-group">
      <.torch_label for={@id}><%= @label %></.torch_label>
      <div class="torch-form-group-input">
        <input
          type={@type}
          name={@name}
          id={@id || @name}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          class={[@errors != [] && "form-field-error"]}
          {@rest}
        />
        <.torch_error :for={msg <- @errors}><%= msg %></.torch_error>
      </div>
    </div>
    """
  end

  @doc """
  Renders a label
  """
  attr(:for, :string, default: nil)
  slot(:inner_block, required: true)

  def torch_label(assigns) do
    ~H"""
    <label for={@for}>
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  @doc """
  Renders generic error message
  """
  attr(:for, :string, default: nil)
  slot(:inner_block, required: true)

  def torch_error(assigns) do
    ~H"""
    <span class="invalid-feedback"><%= render_slot(@inner_block) %></span>
    """
  end

  @doc """
  Returns a formatted group of all flash messages available.

  ## Example

      <.flash_messages flash={conn.assigns.flash} />
  """
  attr(:flash, :map)

  def flash_messages(assigns) do
    ~H"""
    <section id="torch-flash-messages">
      <div class="torch-container">
        <.torch_flash :for={{flash_type, flash_msg} <- @flash} message={flash_msg} flash_type={flash_type} />
      </div>
    </section>
    """
  end

  @doc """
  Renders a simple flash message tag
  """
  attr(:flash_type, :string)
  attr(:message, :string)

  def torch_flash(assigns) do
    ~H"""
    <p class={"torch-flash #{@flash_type}"}><%= @message %>&nbsp;<button class="torch-flash-close">x</button></p>
    """
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate "is invalid" in the "errors" domain
    #     dgettext("errors", "is invalid")
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    # This requires us to call the Gettext module passing our gettext
    # backend as first argument.
    #
    # Note we use the "errors" domain, which means translations
    # should be written to the errors.po file. The :count option is
    # set by Ecto and indicates we should also apply plural rules.
    if count = opts[:count] do
      Gettext.dngettext(Torch.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(Torch.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end

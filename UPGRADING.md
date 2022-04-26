# Upgrading

### Torch v3 to Torch v4

Torch v4 **IS NOT** fully backwards compatible with Torch v3.  In particular, the templates have changed
in a manner that affect the generated DOM and CSS rules used.

To manually update your existing templates to the new v4 DOM do the following:

#### show.html.*

* `<div class="header"></div>` becomes `<header class="header"></header>`
* `<ul><li>...</li></ul>` list for model properties becomes `<section class="torch-show-details"><div class="torch-show-attribute">...</div></section>`

#### form.html.*

Inside `<div class="torch-form-group>...</div>`, the `input` and `error` outputs are now wrapped in an additional div:

    <div class="torch-form-group">
      <%= label %>
      <%= input %>
      <%= error %>
    </div>

becomes:

    <div class="torch-form-group">
      <%= label %>
      <div class="torch-form-group-input">
        <%= input %>
        <%= error %>
      </div>
    </div>


Another option to "upgrade" is to just generate new templates again via the Torch v4 generators.  Run the same
generator commands as the first time and overwrite your existing files.  Then resolve any customization previously
made to your Torch v3 templates by re-applying those change to the newly generated Torch v4 templates.

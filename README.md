# Torch
[![Slackin](https://infiniteredcommunity.herokuapp.com/badge.svg)](https://infiniteredcommunity.herokuapp.com/)
[![Hex.pm](https://img.shields.io/hexpm/v/torch.svg)](https://hex.pm/packages/torch)
[![Build Status](https://semaphoreci.com/api/v1/projects/b2c7b27b-ce6c-4b1c-b2a4-df3390f80380/1248783/shields_badge.svg)](https://semaphoreci.com/ir/torch)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/infinitered/torch.svg)](https://beta.hexfaktor.org/github/infinitered/torch)

Torch is a rapid admin generator for Phoenix apps. It uses generators rather than DSLs to ensure that the code remains maintainable.

## Installation

To install Torch, perform the following steps:

1. Add `torch` to your list of dependencies in `mix.exs`. Then, run `mix deps.get`:

```elixir
def deps do
  [{:torch, "~> 1.0.0-rc.5"}]
end
```

2. Ensure `:torch` is started in your applications list in `mix.exs`:

```elixir
def application do
  [applications: [:torch]]
end
```

3. Add `torch` to your `package.json` dependencies. Then, run `npm install`.

```diff
"dependencies": {
  "phoenix": "file:deps/phoenix",
  "phoenix_html": "file:deps/phoenix_html",
+ "torch": "file:deps/torch"
},
```

4. Import `torch.js` in your `app.js`:

```js
import torch from "torch/priv/static/torch"
```

5. Import `torch.css` in your `app.scss`:

```css
@import "~torch/priv/static/torch";
```

6. Run `mix torch.install (eex|slim)` to install the relevant Torch files. You can choose between `eex` templates and `slim` templates. If you choose to use `slim` templates, you will need to [install Phoenix Slim](https://github.com/slime-lang/phoenix_slime).

7. Set up CSS as described below.

## Setting up CSS

Torch provides its CSS in two ways:

1. A precompiled css file in `priv/static/css/torch.css`.
2. SASS styles in `assets/css/app.sass`

### Customization Using Sass Variables

If you want to customize the look and feel of your admin, you should use the SASS styles. Update your `app.scss` file to look like this:

```css
@import "admin_variables";
@import "~torch/assets/css/app";
```

Then, update your `brunch-config.js` (or asset manager of choice) SASS settings to make it watch your node_modules directory:

```js
plugins: {
  sass: {
    mode: 'native',
    includePaths: ['node_modules']
  }
}
```

Then, simply uncomment and customize the variables in `web/static/css/_admin_variables.scss` to change how Torch is styled.

### Using Precompiled CSS

If you're not using SASS, then you will need to configure your asset pipeline to compile the precompiled `torch.css`. Brunch can be configured to do this like so:

1. Add `node_modules` to the watched directories for `stylesheets`.

```js
stylesheets: {
  joinTo: {
    'css/app.css': /^(web|node_modules)/
  }
}
```

2. Add `torch` to the npm configuration:

```js
npm: {
  enabled: true
  styles: {
    torch: [
      'priv/static/torch.css'
    ]
  }
}
```

### Test CSS Instalation

To test that you have torch styles and static assets installed and bundled properly, you can add a torch test componet to your markup. In HTML, the test components looks like this:

```html
<div class="torch-test-component">
  <div class="fa fa-heart fa-pull-left fa-3x"></div>
  <div class="infinite-red-logo"></div>
</div>
```

When adding the test component to your markup, you should see a FontAwesome heart icon and the Infinte Red logo. This will ensure that Brunch, or your asset builder of choice, correctly built Torch's static assets.

## Usage

Run `mix torch.gen (eex|slim)` to generate admin controllers and views for a given Ecto schema module. Torch expects you to have already defined the schema in your project.
Also, Torch expects you to have `phoenix_slime` installed and configured if you generate `slim` templates.

The full format is as follows:

`mix torch.gen (eex|slim) [Admin | term for admin] [Singular
model term] [plural model term] (sort field) (sort_direction)
(attribute:attribute type)`

For example, if we wanted to generate an admin area for a `Post` model we already have using `eex` templates, we could run this command:

```bash
$ mix torch.gen eex Admin Post posts inserted_at desc title:string body:text inserted_at:date
```

And the output would be:

```bash
Success!

You should now add a route to the new controller to your `router.ex`, within the `:admin` scope:

    scope "/admin", Example.Admin, as: :admin do
      pipe_through :browser

      resources "/posts", PostController
    end

And update the `layout/admin.html.eex` navigation:

    <header id="main-header">
      <nav>
        <h1>Torch Admin</h1>
        <ul>
          <li><%= Torch.NavigationView.nav_link @conn, "Posts", admin_post_path(@conn, :index) %></a>
        </ul>
      </nav>
    </header>
```

The command created the following files for us:

```
web/templates/admin/post/index.html.eex
web/templates/admin/post/edit.html.eex
web/templates/admin/post/new.html.eex
web/templates/admin/post/_form.html.eex
web/templates/admin/post/_filters.html.eex
web/controllers/admin/post_controller.ex
web/views/admin/post_view.ex
```

If you hook up the routes as described above, you'll see a fully featured CRUD interface for posts, including sophisticated filtering, sorting and search at <http://localhost:4000/admin/posts>.

To learn more about the `torch.gen` task, run:

```
mix help torch.gen
```

## Premium Support

[Torch](https://github.com/infinitered/torch), as open source projects, is free to use and always will be. [Infinite Red](https://infinite.red/) offers premium Torch support and general web app design/development services. Email us at [hello@infinite.red](mailto:hello@infinite.red) to get in touch with us for more details.

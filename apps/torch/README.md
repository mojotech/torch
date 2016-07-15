# Torch

Torch is a rapid admin generator for Phoenix apps. It uses generators rather than DSLs to ensure that the code remains maintainable.

## Installation

To install Torch, perform the following steps:

1. Add `torch` to your list of dependencies in `mix.exs`:

    ```elixir
def deps do
  [{:torch, "~> 0.2.0-rc.6"}]
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
import "torch"
```

5. Run `mix torch.install (eex|slim)` to install the relevant Torch files. You can choose between `eex` templates and `slim` templates. If you choose to use `slim` templates, you will need to [install Phoenix Slim](https://github.com/slime-lang/phoenix_slime).

6. Set up CSS as described below.

## Setting up CSS

Torch provides its CSS in two ways:

1. A precompiled css file in `priv/static/css/torch.css`.
2. SASS styles in `web/static/css/torch.sass`

### Customization Using Sass Variables

If you want to customize the look and feel of your admin, you should use the SASS styles. Update your `app.scss` file to look like this:

```css
@import "admin_variables";
@import "../../../node_modules/torch/web/static/css/torch";
```

Then, update your `brunch-config.js` sass settings to make Brunch watch your node_modules directory:

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

## Usage

Run `mix torch.gen (eex|slim)` to generate admin controllers and views for a given Ecto schema module. Torch expects you to have already defined the schema in your project.

For example, if we wanted to generate an admin area for a `Post` model we already have, we could run this command:

```bash
$ mix torch.gen.html Admin Post posts title:string body:text inserted_at:date
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

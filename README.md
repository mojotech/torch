[![Slackin](https://infiniteredcommunity.herokuapp.com/badge.svg)](https://infiniteredcommunity.herokuapp.com/)
[![Hex.pm](https://img.shields.io/hexpm/v/torch.svg)](https://hex.pm/packages/torch)
[![Build Status](https://semaphoreci.com/api/v1/projects/b2c7b27b-ce6c-4b1c-b2a4-df3390f80380/1368593/shields_badge.svg)](https://semaphoreci.com/ir/torch)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/infinitered/torch.svg)](https://beta.hexfaktor.org/github/infinitered/torch)

# Torch

🔥 Torch is a rapid admin generator for Phoenix apps. It creates custom templates and relies
on Phoenix html & context generators under the hood. 🔥

![image](https://user-images.githubusercontent.com/7085617/36333572-70e3907e-132c-11e8-9ad2-bd5e98aadc7c.png)

## :arrow_down: Installation

To install Torch, perform the following steps:

1. Add `torch` to your list of dependencies in `mix.exs`. Then, run `mix deps.get`:

```elixir
def deps do
  [
    {:torch, "~> 2.0.0-alpha"}
  ]
end
```

2. Add a `Plug.Static` plug to your `endpoint.ex`:

```elixir
plug(
  Plug.Static,
  at: "/torch",
  from: {:torch, "priv/static"},
  gzip: true,
  cache_control_for_etags: "public, max-age=86400"
)
```

3. Configure Torch by adding the following to your `config.exs`.

```
config :torch,
  otp_app: :my_app_name,
  template_format: "eex" || "slim"
```

NOTE: If you choose to use `slim` templates, you will need to [install Phoenix Slim](https://github.com/slime-lang/phoenix_slime).

Now you're ready to start generating your admin! :tada:

## :wrench: Usage

Torch uses Phoenix generators under the hood. Torch injects it's own custom templates
into your `priv/static` directory, then runs the `mix phx.gen.html` task with the options
you passed in. Finally, it uninstalls the custom templates so they don't interfere with
running the plain Phoenix generators.

In light of that fact, the `torch.gen.html` task takes all the same arguments as the `phx.gen.html`,
but does some extra configuration on either end. Checkout `mix help phx.gen.html` for more details
about the supported options and format.

For example, if we wanted to generate a blog with a `Post` model we could run the following command:

```bash
$ mix torch.gen.html Blog Post posts title:string body:text published_at:datetime published:boolean views:integer
```

The output would look like:

```bash
Add the resource to your browser scope in lib/my_app_web/router.ex:

    resources "/posts", PostController

Ensure the following is added to your endpoint.ex:

    plug(
      Plug.Static,
      at: "/torch",
      from: {:torch, "priv/static"},
      gzip: true,
      cache_control_for_etags: "public, max-age=86400",
      headers: [{"access-control-allow-origin", "*"}]
    )

🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
                        Torch generated html for Posts!
🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
```

Torch also installed an admin layout into your `my_app_web/templates/layout/admin.html.eex`.
You will want to update it to include your new navigation link:

```
<nav class="torch-nav">
  <a href="/posts">Posts</a>
</nav>
```

## Styling

Torch generates two CSS themes you can use: `base.css` & `theme.css`.
The base styles are basically bare bones, and the theme styles look like the screenshot
above. Just change the stylesheet link in the `admin.html.eex` layout.

If you want to use the theme, but override the colors, you'll need to include your
own stylesheet with the specific overrides.

## Premium Support

Elavon, as an open source project, is free to use and always will be. [Infinite Red](https://infinite.red) offers premium Torch support and general web &
mobile app design/development services. Get in touch [here](https://infinite.red/contact) or email us at [hello@infinite.red](mailto:hello@infinite.red).

![Infinite Red Logo](https://infinite.red/images/infinite_red_logo_colored.png)
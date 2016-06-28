# Torch

[![Build Status](https://semaphoreci.com/api/v1/projects/b2c7b27b-ce6c-4b1c-b2a4-df3390f80380/870178/badge.svg)](https://semaphoreci.com/ir/torch)

A rapid admin generator for Phoenix apps. See more details in the [README](/apps/torch/README.md).

## Development 

Because Torch relies on generators, the development environment needs to let you see the generated code in action. Accordingly, this repo is a Mix [umbrella app](http://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-apps.html).

- **apps/torch**: The actual Torch Hex package, including the generators.
- **apps/example**: A sample Phoenix app, using Torch. By running the Phoenix app, you can see Torch-generated code in action.

Follow these steps to set up your environment:

1. Run `bin/setup`.
2. In one terminal tab, `cd apps/torch` and run `./node_modules/brunch/bin/brunch watch`.
3. In another terminal tab, `cd apps/example` and run `mix phoenix.server`.

You can then visit `localhost:4000/admin/posts` and see a Torch-generated admin.

If you make a change to one of the generators, you can run `mix regenerate` inside `apps/example` to regenerate the Torch code.

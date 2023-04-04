# Used by "mix format"
[
  inputs: ["mix.exs", "{config,lib,test}/**/*.{ex,exs}", "test/{mix,torch}/**/*.{ex,exs}"],
  locals_without_parens: [
    # Phoenix
    plug: 2,
    plug: 1,
    pipe_through: 1,
    get: 3,
    post: 3,
    patch: 3,
    put: 3,
    forward: 3
  ]
]

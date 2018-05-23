use Mix.Config

config :example, ecto_repos: [Example.Repo]
config :ecto, :json_library, Jason

import_config "#{Mix.env}.exs"

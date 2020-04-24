defmodule Phx15.Repo do
  use Ecto.Repo,
    otp_app: :phx1_5,
    adapter: Ecto.Adapters.Postgres
end

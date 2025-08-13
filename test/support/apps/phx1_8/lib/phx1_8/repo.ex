defmodule Phx18.Repo do
  use Ecto.Repo,
    otp_app: :phx1_8,
    adapter: Ecto.Adapters.Postgres
end

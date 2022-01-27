defmodule Phx16.Repo do
  use Ecto.Repo,
    otp_app: :phx1_6,
    adapter: Ecto.Adapters.Postgres
end

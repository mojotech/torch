defmodule Phx15Slime.Repo do
  use Ecto.Repo,
    otp_app: :phx1_5_slime,
    adapter: Ecto.Adapters.Postgres
end

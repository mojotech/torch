defmodule Example.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :sign_up_complete, :boolean, default: false, null: false
      add :signed_up_at, :naive_datetime

      timestamps()
    end

  end
end

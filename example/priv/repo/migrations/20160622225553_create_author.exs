defmodule Example.Repo.Migrations.CreateAuthor do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :name, :string
      add :email, :string

      timestamps
    end
  end
end

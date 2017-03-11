defmodule Example.Repo.Migrations.AddDraftToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :draft, :boolean, default: false
    end
  end
end

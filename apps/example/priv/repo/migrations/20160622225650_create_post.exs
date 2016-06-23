defmodule Example.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :text
      add :author_id, references(:authors, on_delete: :nothing)

      timestamps
    end

    create index(:posts, [:author_id])
  end
end

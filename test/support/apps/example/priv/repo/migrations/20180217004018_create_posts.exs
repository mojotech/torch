defmodule Example.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :subtitle, :string
      add :description, :text
      add :published_at, :utc_datetime
      add :published, :boolean, default: false, null: false
      add :views, :integer

      timestamps()
    end

  end
end

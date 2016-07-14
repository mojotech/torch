defmodule Example.Repo.Migrations.AddCategoryIdToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :category_id, references(:categories, on_delete: :nilify_all)
    end
  end
end

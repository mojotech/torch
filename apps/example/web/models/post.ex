defmodule Example.Post do
  use Example.Web, :model

  schema "posts" do
    belongs_to :author, Example.Author
    belongs_to :category, Example.Category

    field :title, :string
    field :body, :string
    field :draft, :boolean

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :draft, :category_id, :author_id])
    |> validate_required([:title, :body, :draft])
  end
end

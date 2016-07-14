defmodule Example.Post do
  use Example.Web, :model

  schema "posts" do
    field :title, :string
    field :body, :string
    field :draft, :boolean
    belongs_to :author, Example.Author

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :draft])
    |> validate_required([:title, :body, :draft])
  end
end

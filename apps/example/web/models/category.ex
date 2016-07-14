defmodule Example.Category do
  use Example.Web, :model

  schema "categories" do
    has_many :posts, Example.Post

    field :name, :string

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end

defmodule Example.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Example.Blog.Post


  schema "posts" do
    field :description, :string
    field :published, :boolean, default: false
    field :published_at, :utc_datetime
    field :subtitle, :string
    field :title, :string
    field :views, :integer

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :subtitle, :description, :published_at, :published, :views])
    |> validate_required([:title, :subtitle, :description, :published_at, :published, :views])
  end
end

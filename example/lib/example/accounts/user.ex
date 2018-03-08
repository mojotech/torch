defmodule Example.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Example.Accounts.User


  schema "users" do
    field :email, :string
    field :name, :string
    field :sign_up_complete, :boolean, default: false
    field :signed_up_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :sign_up_complete, :signed_up_at])
    |> validate_required([:name, :email, :sign_up_complete, :signed_up_at])
  end
end

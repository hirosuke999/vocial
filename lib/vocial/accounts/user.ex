defmodule Vocial.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Vocial.Accounts.User

  schema "users" do
    field :username, :string
    field :email, :string
    field :active, :boolean, default: true
    field :encrypted_password, :string

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :active])
    |> validate_required([:username, :email, :active])
  end
end

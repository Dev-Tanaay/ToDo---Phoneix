defmodule Install.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pbkdf2

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    field :password_input, :string, virtual: true
    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :email, :password_input])
    |> validate_required([:name, :email, :password_input])
    |> validate_length(:password_input, min: 8)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password_input: password_input}} = changeset) do
    change(changeset, password: Pbkdf2.hash_pwd_salt(password_input))
  end

  defp put_password_hash(changeset), do: changeset
end

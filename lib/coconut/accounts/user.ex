defmodule Coconut.Accounts.User do
  @moduledoc """
  User schema
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :uid, :string
    field :email, :string
    field :name, :string
    field :avatar, :string

    timestamps()
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  """
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:uid, :email, :name, :avatar])
    |> validate_email()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Coconut.Repo)
    |> unique_constraint(:email)
  end
end

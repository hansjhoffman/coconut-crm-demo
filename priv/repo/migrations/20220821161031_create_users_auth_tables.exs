defmodule Coconut.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS citext", "")

    create table(:users, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:email, :citext, null: false)
      add(:name, :string, null: false)
      add(:uid, :string, null: false)
      add(:avatar, :string, null: false)

      timestamps()
    end

    create(unique_index(:users, [:email]))
  end
end

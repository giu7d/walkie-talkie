defmodule WalkieTalkie.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :email, :string, null: false

      timestamps()
    end

    create unique_index(:accounts, [:email])
  end
end

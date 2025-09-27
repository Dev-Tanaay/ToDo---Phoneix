defmodule Install.Repo.Migrations.User do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :task, :string, null: false
      add :completed, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tasks, [:user_id])
  end
end

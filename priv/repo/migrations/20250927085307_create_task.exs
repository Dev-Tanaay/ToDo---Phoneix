defmodule Install.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    drop_if_exists table(:tasks);
    create table(:tasks) do
      add :task, :string, null: false
      add :completed, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tasks, [:user_id])
  end
end

defmodule Install.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :task, :string
    field :completed, :boolean, default: false
    belongs_to :user, Install.User
  end

  def changeset(task, params \\ %{}) do
    task
    |> cast(params, [:task, :completed])
    |> validate_required([:task, :completed])
  end
end

defmodule Segfault.Repo.Migrations.CreateQuestion do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :title, :string
      add :content, :string
      add :points, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:questions, [:user_id])

  end
end

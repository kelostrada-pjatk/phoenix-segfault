defmodule Segfault.Repo.Migrations.CreateAnswer do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :content, :string, null: false
      add :points, :integer, null: false
      add :question_id, references(:questions, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps
    end
    create index(:answers, [:question_id])
    create index(:answers, [:user_id])

  end
end

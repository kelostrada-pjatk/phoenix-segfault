defmodule Segfault.Repo.Migrations.NotNullFields do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      modify :title, :string, null: false
      modify :content, :string, null: false
      modify :user_id, :integer, null: false
      modify :points, :integer, null: false
    end

    alter table(:users) do
      modify :name, :string, null: false
      modify :email, :string, null: false
      modify :points, :integer, null: false
    end
  end
end

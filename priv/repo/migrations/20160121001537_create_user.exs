defmodule Segfault.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :points, :integer

      timestamps
    end

  end
end

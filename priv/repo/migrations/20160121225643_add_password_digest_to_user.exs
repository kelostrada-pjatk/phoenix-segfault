defmodule Segfault.Repo.Migrations.AddPasswordDigestToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
        add :password_digest, :string, size: 64
      end
  end
end

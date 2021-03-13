defmodule EventManager.Repo.Migrations.UnrequireProfileHash do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :profile_hash, :text, null: true
    end
  end
end

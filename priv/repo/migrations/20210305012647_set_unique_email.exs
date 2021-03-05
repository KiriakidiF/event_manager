defmodule EventManager.Repo.Migrations.SetUniqueEmail do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:email])
  end
end

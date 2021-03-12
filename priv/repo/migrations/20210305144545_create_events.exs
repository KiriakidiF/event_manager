defmodule EventManager.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string, null: false
      add :date, :utc_datetime, null: false
      add :desc, :string, null: false


      add :owner_id, references(:users), null: false
      #TODO ADD list of invites reference
      #TODO add list of comments reference

      timestamps()
    end
  end
end

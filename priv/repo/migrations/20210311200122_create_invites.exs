defmodule EventManager.Repo.Migrations.CreateInvites do
  use Ecto.Migration

  def change do
    create table(:invites) do
      add :response, :string, default: "", null: false
      add :event_id,
        references(:events,
          on_delete: :delete_all)
      add :user_email, :string, null: false

      timestamps()
    end

    create index(:invites, [:event_id])
  end
end

defmodule EventManager.Repo.Migrations.CreateInvites do
  use Ecto.Migration

  def change do
    create table(:invites) do
      add :response, :string, default: "", null: false
      add :event_id,
        references(:events,
          on_delete: :delete_all)
      add :user_email,
        references(:users,
          on_delete: :nothing)

      timestamps()
    end

    create index(:invites, [:event_id])
    create index(:invites, [:user_email])
  end
end

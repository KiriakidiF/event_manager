defmodule EventManager.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :date, :utc_datetime
    field :desc, :string
    field :name, :string

    belongs_to :owner, EventManager.Users.User

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :date, :desc, :owner_id])
    |> validate_required([:name, :date, :desc, :owner_id])
  end
end

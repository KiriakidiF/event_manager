defmodule EventManager.Invites.Invite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invites" do
    field :response, :string, default: ""
    belongs_to :event, EventManager.Events.Event

    field :user_email, :string

    timestamps()
  end

  @doc false
  def changeset(invite, attrs) do
    IO.inspect(attrs)
    invite
    |> cast(attrs, [:response, :user_email, :event_id])
    |> validate_required([:user_email, :event_id])
    |> validate_format(:user_email, ~r/@/)
  end
end

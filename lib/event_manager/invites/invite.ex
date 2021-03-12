defmodule EventManager.Invites.Invite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invites" do
    field :response, :boolean, default: nil
    belongs_to :event, EventManager.Events.Event

    belongs_to :user, EventManager.Users.User,
      foreign_key: :user_email

    timestamps()
  end

  @doc false
  def changeset(invite, attrs) do
    invite
    |> cast(attrs, [:response, :user_email])
    |> validate_required([:response, :user_email])
  end
end

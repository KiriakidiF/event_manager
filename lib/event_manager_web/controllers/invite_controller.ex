defmodule EventManagerWeb.InviteController do
  use EventManagerWeb, :controller

  alias EventManager.Invites
  alias EventManager.Invites.Invite

  alias EventManager.Events

  def index(conn, %{"event_id" => event_id}) do
    event = Events.get_event!(event_id)
    invites = event.invites
    IO.inspect(invites)
    render(conn, "index.html", invites: invites, event_id: event_id)
  end

  def new(conn, %{"event_id" => event_id}) do
    changeset = Invites.change_invite(%Invite{})
    render(conn, "new.html", changeset: changeset, event_id: event_id)
  end

  #def create(conn, %{"invite" => invite_params}) do
  def create(conn, %{"invite" => invite_params, "event_id" => event_id}) do
    invite_params = invite_params
    |> Map.put("event_id", event_id)
    case Invites.create_invite(invite_params) do
      {:ok, invite} ->
        conn
        |> put_flash(:info, "Invite created successfully.")
        |> redirect(to: Routes.invite_path(conn, :show, invite, event_id: event_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset, event_id: event_id)
    end
  end

  def show(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    render(conn, "show.html", invite: invite)
  end

  def edit(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    changeset = Invites.change_invite(invite)
    render(conn, "edit.html", invite: invite, changeset: changeset)
  end

  def update(conn, %{"id" => id, "invite" => invite_params}) do
    invite = Invites.get_invite!(id)
    IO.inspect(invite)
    IO.inspect(invite_params)
    case Invites.update_invite(invite, invite_params) do
      {:ok, invite} ->
        conn
        |> put_flash(:info, "Invite updated successfully.")
        |> redirect(to: Routes.invite_path(conn, :show, invite))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", invite: invite, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    {:ok, _invite} = Invites.delete_invite(invite)

    conn
    |> put_flash(:info, "Invite deleted successfully.")
    |> redirect(to: Routes.invite_path(conn, :index))
  end
end

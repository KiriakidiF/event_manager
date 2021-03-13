defmodule EventManagerWeb.EventController do
  use EventManagerWeb, :controller

  alias EventManager.Events
  alias EventManager.Events.Event

  #alias EventManager.Invites

  alias EventManagerWeb.Plugs
  plug Plugs.PutRedirect when action in
    [:show]
  plug Plugs.RequireUser
  plug :fetch_event when action in
    [:show, :edit, :update, :delete]
  plug :require_owner when action in
    [:edit, :update, :delete]
  plug :require_access when action in [:show]
  #todo make sure user has access to show specific event

  def require_access(conn, _args) do
    event = conn.assigns[:event]

    if is_current_user?(conn, event.owner_id)
      || is_invited_user?(conn, event) do
      conn
    else
      conn
      |> put_flash(:error, "You do not have access to view this event.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def require_owner(conn, _args) do
    event = conn.assigns[:event]
    user = conn.assigns[:current_user]

    if event.owner_id == user.id do
      conn
    else
      conn
      |> put_flash(:error, "You must be the owner to edit this event.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  #fetches an event with a given id in conn
  def fetch_event(conn, _args) do
    id = conn.params["id"]
    event = Events.get_event!(id)
    invites = event.invites;
    #TODO ADD User Accces so invites can view
    conn = assign(conn, :event, event)
    assign(conn, :invites, invites)
  end

  def index(conn, _params) do
    events = Events.list_events()
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = Events.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    event_params = event_params
    |> Map.put("owner_id", conn.assigns[:current_user].id)
    |> Map.put("invites", [])
    case Events.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id, "invited" => true}) do
    event = conn.assigns[:event]
    invites = conn.assigns[:invites]
    conn |> put_flash(:info, "Invite Link: " <>
      current_url(conn, %{id: id}))
    render(conn, "show.html", event: event, invites: invites)
  end

  def show(conn, %{"id" => _id}) do
    event = conn.assigns[:event]
    invites = conn.assigns[:invites]
    render(conn, "show.html", event: event, invites: invites)
  end

  def edit(conn, %{"id" => _id}) do
    event = conn.assigns[:event]
    changeset = Events.change_event(event)

    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => _id, "event" => event_params}) do
    event = conn.assigns[:event]

    case Events.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => _id}) do
    event = conn.assigns[:event]
    {:ok, _event} = Events.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :index))
  end
end

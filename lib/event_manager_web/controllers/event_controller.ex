defmodule EventManagerWeb.EventController do
  use EventManagerWeb, :controller

  alias EventManager.Events
  alias EventManager.Events.Event

  alias EventManagerWeb.Plugs
  plug Plugs.RequireUser
  plug :fetch_post when action in
    [:show, :edit, :update, :delete]
  plug :require_owner when action in
    [:edit, :update, :delete]
  #todo make sure user has access to show specific event

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

  #fetches a pose with a given id in conn
  def fetch_post(conn, _args) do
    id = conn.params["id"]
    event = Events.get_event!(id)
    #TODO ADD User Accces so invites can view

    assign(conn, :event, event)
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
    case Events.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => _id}) do
    event = conn.assigns[:event]
    render(conn, "show.html", event: event)
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

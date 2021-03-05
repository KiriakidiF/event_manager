defmodule EventManagerWeb.PageController do
  use EventManagerWeb, :controller

  alias EventManager.Events

  def index(conn, _params) do
    events = Events.list_events()
    render(conn, "index.html", events: events)
  end

  def register(conn, _params) do
    render(conn, "register.html")
  end
end

defmodule EventManagerWeb.PageController do
  use EventManagerWeb, :controller

  alias EventManager.Events

  alias EventManagerWeb.Plugs
  plug Plugs.PutRedirect

  def index(conn, _params) do
    events = Events.list_events()
    render(conn, "index.html", events: events)
  end
end

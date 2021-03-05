defmodule EventManagerWeb.PageController do
  use EventManagerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def register(conn, _params) do
    render(conn, "register.html")
  end
end

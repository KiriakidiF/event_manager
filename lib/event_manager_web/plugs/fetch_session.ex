defmodule EventManagerWeb.Plugs.FetchSession do
  import Plug.Conn

  use EventManagerWeb, :controller

  def init(args), do: args

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _args) do
    user_id = get_session(conn, :login_id) || -1
    user = EventManager.Users.get_user(user_id)
    conn = if user do
      assign(conn, :current_user, user)
    else
      assign(conn, :current_user, nil)
    end

    redirect = get_session(conn, :redirect)
    IO.inspect(redirect)
    if redirect do
      assign(conn, :redirect, redirect)
    else
      assign(conn, :redirect,
        current_path(conn))
    end
  end

  # conn.assigns[:current_user]
  # <%= @current_user.name %>
end

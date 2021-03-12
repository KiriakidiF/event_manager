defmodule EventManagerWeb.Plugs.RequireUser do
  use EventManagerWeb, :controller

  def init(args), do: args

  def call(conn, _args) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must first log in.")
      |> redirect(to: Routes.user_path(conn, :register))
      |> halt()
    end
  end
end

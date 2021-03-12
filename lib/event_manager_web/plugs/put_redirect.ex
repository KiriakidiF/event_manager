defmodule EventManagerWeb.Plugs.PutRedirect do
  import Plug.Conn

  use EventManagerWeb, :controller

  def init(args), do: args

  def call(conn, _args) do
    conn = put_session(conn, :redirect,
      current_path(conn))
    conn
  end
end

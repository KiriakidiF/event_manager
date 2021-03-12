# This format is taken from the Lecture notes 11-photoblog
defmodule EventManagerWeb.SessionController do
  use EventManagerWeb, :controller

  def create(conn, %{"email" => email}) do
    login = EventManager.Users.get_user_by_email(email)
    IO.inspect("create session")
    IO.inspect(get_session(conn, :redirect))
    if login do
      conn
      |> put_session(:login_id, login.id)
      |> put_flash(:info, "Welcome #{login.name}")
      |> assign(:current_user, login)
      |> redirect(to: get_session(conn, :redirect))
    else
      conn
      |> delete_session(:login_id)
      |> put_flash(:error, "Failed to Login")
      |> redirect(to: get_session(conn, :redirect))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:login_id)
    |> put_flash(:info, "Successfully logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end

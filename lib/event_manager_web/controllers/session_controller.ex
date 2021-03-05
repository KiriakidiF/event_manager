# This format is taken from the Lecture notes 11-photoblog
defmodule EventManagerWeb.SessionController do
  use EventManagerWeb, :controller

  def create(conn, %{"email" => email}) do
    login = EventManager.Users.get_user_by_email(email)
    if login do
      conn
      |> put_session(:login_id, login.id)
      |> put_flash(:info, "Welcome #{login.name}")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> delete_session(:login_id)
      |> put_flash(:error, "Failed to Login")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:login_id)
    |> put_flash(:info, "Successfully logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end

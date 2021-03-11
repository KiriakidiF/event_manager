defmodule EventManagerWeb.Helpers do
  def have_current_user?(conn) do
    conn.assigns[:current_user] != nil
  end

  def is_current_user?(conn, user_id) do
    user = conn.assigns[:current_user]
    user && user.id == user_id
  end
end

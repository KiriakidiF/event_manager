defmodule EventManagerWeb.UserController do
  use EventManagerWeb, :controller

  alias EventManager.Users
  alias EventManager.Users.User

  alias EventManager.Photos

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def register(conn, _args) do
    changeset = Users.change_user(%User{})
    render(conn, "register.html", changeset: changeset)
  end

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    up = user_params["profile"]
    user_params =
      if up do
        {:ok, hash} = Photos.save_photo(up.filename, up.path)
        user_params = user_params
        |> Map.put("profile_hash", hash)
        user_params
      else
        user_params
      end

    case Users.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: get_session(conn, :redirect))
          #to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "register.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)
    up = user_params["profile"]

    user_params = if up do
      #TODO remove old image
      {:ok, hash} = Photos.save_photo(up.filename, up.path)
      Map.put(user_params, "profile_hash", hash)
    else
      user_params
    end

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def photo(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _name, data} = Photos.load_photo(user.profile_hash)
    conn
    |> put_resp_content_type("image/jpeg")
    |> send_resp(200, data)
  end

  def delete(conn, %{"id" => id}) do
    #TODO Remove old profile image
    user = Users.get_user!(id)
    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end

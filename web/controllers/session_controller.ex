defmodule Segfault.SessionController do
  use Segfault.Web, :controller
  alias Segfault.User
  import Comeonin.Bcrypt, only: [checkpw: 2]

  # cleanup of blank user input
  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params) do
    render conn, "new.html", changeset: User.changeset(%User{})
  end

  def create(conn, %{"user" => %{"name" => name, "password" => password}})
  when not is_nil(name) and not is_nil(password) do
    user = Repo.get_by(User, name: name)
    sign_in(user, password, conn)
  end

  def create(conn, _) do
    failed_login(conn)
  end

  def delete(conn, _params) do
    delete_session(conn, :current_user)
    |> put_flash(:info, "Signed out successfully!")
    |> redirect(to: question_path(conn, :index))
  end

  defp sign_in(user, _password, conn) when is_nil(user) do
    failed_login(conn)
  end

  defp sign_in(user, password, conn) do
    if checkpw(password, user.password_digest) do
      put_session(conn, :current_user, %{id: user.id, name: user.name, points: user.points})
      |> put_flash(:info, "Sign in successful!")
      |> redirect(to: question_path(conn, :index))
    else
      failed_login(conn)
    end
  end

  defp failed_login(conn) do
    put_session(conn, :current_user, nil)
    |> put_flash(:error, "Invalid username/password combination!")
    |> redirect(to: question_path(conn, :index))
    |> halt()
  end

end
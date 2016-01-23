defmodule Segfault.SessionController do
  use Segfault.Web, :controller
  alias Segfault.User
  import Comeonin.Bcrypt, only: [checkpw: 2]

  # cleanup of blank user input
  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params) do
    render conn, "new.html", changeset: User.changeset(%User{})
  end

  def create(conn, %{"user" => user_params}) do
    user = Repo.get_by(User, name: user_params["name"])
    sign_in(user, user_params["password"], conn)
  end

  defp sign_in(user, _password, conn) when is_nil(user) do
    put_flash(conn, :error, "Invalid username/password combination!")
    |> redirect(to: page_path(conn, :index))
  end

  defp sign_in(user, password, conn) do
    if checkpw(password, user.password_digest) do
      put_session(conn, :current_user, %{id: user.id, name: user.name})
      |> put_flash(:info, "Sign in successful!")
      |> redirect(to: page_path(conn, :index))
    else
      put_session(conn, :current_user, nil)
      |> put_flash(:error, "Invalid username/password combination!")
      |> redirect(to: page_path(conn, :index))
    end
  end

end
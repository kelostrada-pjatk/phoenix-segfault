defmodule Segfault.Plugs.CurrentUser do
  import Plug.Conn

  alias Segfault.User

  def init(default), do: default

  def call(conn, _params) do
    user = Plug.Conn.get_session(conn, :current_user)
    if not is_nil(user) and is_nil(conn.assigns[:current_user]) do
      db_user = Segfault.Repo.get_by(User, %{id: user.id})
      conn = assign(conn, :current_user, db_user)
    end
    conn
  end

end
defmodule Segfault.Plugs.Authenticate do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _)  do
    user = Plug.Conn.get_session(conn, :current_user)
    if not is_nil(user) do
      assign(conn, :user, user)
    else
      conn
      |> Phoenix.Controller.put_flash(:warning, "User is not authenticated.")
      |> Phoenix.Controller.redirect(to: "/")
      |> halt
    end
  end

end
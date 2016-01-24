defmodule Segfault.Plugs.Authorize do
  import Plug.Conn

  def init(default), do: default

  def call(conn, params)  do
    if conn.assigns[params].user_id != conn.assigns[:user].id do
      conn
      |> Phoenix.Controller.put_flash(:warning, "User is not authorized.")
      |> Phoenix.Controller.redirect(to: "/")
      |> halt
    else
      conn
    end
  end

end
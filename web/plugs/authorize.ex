defmodule Segfault.Plugs.Authorize do
  import Plug.Conn
  import Segfault.Router.Helpers, only: [question_path: 2]

  def init(default), do: default

  def call(conn, params)  do
    if conn.assigns[params].user_id != conn.assigns[:user].id do
      conn
      |> Phoenix.Controller.put_flash(:warning, "User is not authorized.")
      |> Phoenix.Controller.redirect(to: question_path(conn, :index))
      |> halt
    else
      conn
    end
  end

end
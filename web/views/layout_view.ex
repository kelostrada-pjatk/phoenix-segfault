defmodule Segfault.LayoutView do
  use Segfault.Web, :view
  alias Segfault.User
  alias Segfault.Repo

  def current_user(conn) do
    user = Plug.Conn.get_session(conn, :current_user)
    if not is_nil(user) do
      Repo.get_by(User, %{id: user.id})
    end
  end
end

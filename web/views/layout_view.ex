defmodule Segfault.LayoutView do
  use Segfault.Web, :view

  def current_user(conn) do
    conn.assigns[:current_user]
  end
end

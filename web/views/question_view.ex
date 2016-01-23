defmodule Segfault.QuestionView do
  use Segfault.Web, :view

  def current_user(conn) do
    Segfault.LayoutView.current_user(conn)
  end
end

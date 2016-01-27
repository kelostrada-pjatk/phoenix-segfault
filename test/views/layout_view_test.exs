defmodule Segfault.LayoutViewTest do
  use Segfault.ConnCase
  alias Segfault.LayoutView
  alias Segfault.User

  setup do
    User.changeset(%User{}, %{name: "test", password: "test", password_confirmation: "test", email: "test@test.com"})
    |> Repo.insert
    {:ok, conn: conn()}
  end

  test "current user returns the user with points in the session", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: %{name: "test", password: "test"}
    conn = get conn, "/"
    current_user = LayoutView.current_user(conn)
    assert current_user
    assert current_user.name == "test"
    assert current_user.points
  end

  test "current user returns nothing if there is no user in the session" do
    user = Repo.get_by(User, %{name: "test"})
    conn = delete conn, session_path(conn, :delete, user.id)
    refute LayoutView.current_user(conn)
  end

  test "deletes the user session if it exists", %{conn: conn} do
    user = Repo.get_by(User, %{name: "test"})
    conn = delete conn, session_path(conn, :delete, user)
    assert redirected_to(conn) == question_path(conn, :index)
    assert get_flash(conn, :info) == "Signed out successfully!"
    refute get_session(conn, :current_user)
    refute LayoutView.current_user(conn)
    conn = get conn, "/"
    refute get_session(conn, :current_user)
    refute LayoutView.current_user(conn)
  end
end
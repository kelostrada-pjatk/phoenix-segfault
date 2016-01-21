defmodule Segfault.UserTest do
  use Segfault.ModelCase

  alias Segfault.User

  @valid_attrs %{email: "some content", name: "some content", points: 0,
                 password: "some content", password_confirmation: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end

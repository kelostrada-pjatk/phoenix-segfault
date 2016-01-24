defmodule Segfault.AnswerControllerTest do
  use Segfault.ConnCase

  alias Segfault.User
  alias Segfault.Question
  alias Segfault.Answer

  @valid_attrs %{content: "some content", points: 0}
  @invalid_attrs %{content: ""}

  setup do
    changeset = User.changeset(%User{}, %{name: "test", email: "test@test.com", password: "test", password_confirmation: "test"})
    user = Repo.insert!(changeset)
    Question.changeset(%Question{user_id: user.id}, %{content: "some content", title: "some title", points: 0})
    |> Repo.insert
    conn = conn()
    conn = post conn, session_path(conn, :create), user: %{name: "test", password: "test"}
    {:ok, conn: conn}
  end

  defp question_id do
    Repo.get_by(Question, title: "some title").id
  end

  test "lists all answers on index", %{conn: conn} do
    conn = get conn, question_answer_path(conn, :index, question_id)
    assert html_response(conn, 200) =~ "Listing answers"
  end


  test "renders form for new answers", %{conn: conn} do
    conn = get conn, question_answer_path(conn, :new, question_id)
    assert html_response(conn, 200) =~ "New answer"
  end

  test "creates answer and redirects to its question when data is valid", %{conn: conn} do
    conn = post conn, question_answer_path(conn, :create, question_id), answer: @valid_attrs
    assert redirected_to(conn) == question_path(conn, :show, question_id)
    assert Repo.get_by(Answer, @valid_attrs)
  end
  """
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, answer_path(conn, :create), answer: @invalid_attrs
    assert html_response(conn, 200) =~ "New answer"
  end

  test "shows chosen resource", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    conn = get conn, answer_path(conn, :show, answer)
    assert html_response(conn, 200) =~ "Show answer"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, answer_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    conn = get conn, answer_path(conn, :edit, answer)
    assert html_response(conn, 200) =~ "Edit answer"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    conn = put conn, answer_path(conn, :update, answer), answer: @valid_attrs
    assert redirected_to(conn) == answer_path(conn, :show, answer)
    assert Repo.get_by(Answer, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    conn = put conn, answer_path(conn, :update, answer), answer: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit answer"
  end

  test "deletes chosen resource", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    conn = delete conn, answer_path(conn, :delete, answer)
    assert redirected_to(conn) == answer_path(conn, :index)
    refute Repo.get(Answer, answer.id)
  end
  """
end

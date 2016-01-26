defmodule Segfault.AnswerControllerTest do
  use Segfault.ConnCase

  alias Segfault.User
  alias Segfault.Question
  alias Segfault.Answer

  @valid_attrs %{content: "some content", points: 0}
  @invalid_attrs %{content: ""}
  @user_attrs %{name: "test", email: "test@test.com", password: "test", password_confirmation: "test"}
  @question_attrs %{content: "some content", title: "some title", points: 0}

  setup do
    changeset = User.changeset(%User{}, @user_attrs)
    user = Repo.insert!(changeset)
    Question.changeset(%Question{user_id: user.id}, @question_attrs)
    |> Repo.insert
    conn = conn()
    conn = post conn, session_path(conn, :create), user: %{name: "test", password: "test"}
    {:ok, conn: conn}
  end

  defp user_id do
    Repo.get_by(User, name: "test").id
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

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, question_answer_path(conn, :create, question_id), answer: @invalid_attrs
    assert html_response(conn, 200) =~ "New answer"
  end

  test "shows chosen resource", %{conn: conn} do
    answer = Repo.insert! %Answer{question_id: question_id}
    conn = get conn, question_answer_path(conn, :show, question_id, answer)
    assert html_response(conn, 200) =~ "Show answer"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, question_answer_path(conn, :show, question_id, -1)
    end
  end

  test "renders page not found when answer does not belong to question", %{conn: conn} do
    changeset = Question.changeset(%Question{user_id: user_id}, %{content: "other content", title: "other title", points: 0})
    newquestion = Repo.insert!(changeset)
    answer = Repo.insert! %Answer{question_id: newquestion.id}
    assert_error_sent 404, fn ->
      get conn, question_answer_path(conn, :show, question_id, answer.id)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    answer = Repo.insert! %Answer{question_id: question_id}
    conn = get conn, question_answer_path(conn, :edit, question_id, answer)
    assert html_response(conn, 200) =~ "Edit answer"
  end

  test "renders page not found when answer does not belong to question when editing answer", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    assert_error_sent 404, fn ->
      get conn, question_answer_path(conn, :edit, question_id, answer)
    end
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    answer = Repo.insert! %Answer{question_id: question_id}
    conn = put conn, question_answer_path(conn, :update, question_id, answer), answer: @valid_attrs
    assert redirected_to(conn) == question_answer_path(conn, :show, question_id, answer)
    assert Repo.get_by(Answer, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    answer = Repo.insert! %Answer{question_id: question_id}
    conn = put conn, question_answer_path(conn, :update, question_id, answer), answer: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit answer"
  end

  test "deletes chosen resource", %{conn: conn} do
    answer = Repo.insert! %Answer{question_id: question_id}
    conn = delete conn, question_answer_path(conn, :delete, question_id, answer)
    assert redirected_to(conn) == question_answer_path(conn, :index, question_id)
    refute Repo.get(Answer, answer.id)
  end

end

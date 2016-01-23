defmodule Segfault.QuestionController do
  use Segfault.Web, :controller

  alias Segfault.User
  alias Segfault.Question

  plug :scrub_params, "question" when action in [:create, :update]
  plug :authenticate when action in [:new, :create, :edit, :update, :delete]
  plug :find_question when action in [:show, :edit, :update, :delete]
  plug :authorize when action in [:edit, :update, :delete]

  def index(conn, _params) do
    questions = Repo.all(from q in Question, preload: [:user])
    render(conn, "index.html", questions: questions)
  end

  def new(conn, _params) do
    changeset = Question.changeset(%Question{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"question" => question_params}) do
    user = current_user(conn)
    changeset = Question.changeset(%Question{user_id: user.id}, question_params)

    case Repo.insert(changeset) do
      {:ok, _question} ->
        conn
        |> put_flash(:info, "Question created successfully.")
        |> redirect(to: question_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    question = Repo.get!(Question, id)
    question = Repo.preload question, :user
    render(conn, "show.html", question: question)
  end

  def edit(conn, %{"id" => id}) do
    question = Repo.get!(Question, id)
    changeset = Question.changeset(question)
    render(conn, "edit.html", question: question, changeset: changeset)
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Repo.get!(Question, id)
    changeset = Question.changeset(question, question_params)

    case Repo.update(changeset) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "Question updated successfully.")
        |> redirect(to: question_path(conn, :show, question))
      {:error, changeset} ->
        render(conn, "edit.html", question: question, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Repo.get!(Question, id)
    Repo.delete!(question)

    conn
    |> put_flash(:info, "Question deleted successfully.")
    |> redirect(to: question_path(conn, :index))
  end

  ############################
  # Here we define our Plugs #
  ############################

  defp authenticate(conn, _) do
    user = Plug.Conn.get_session(conn, :current_user)
    if not is_nil(user) do
      assign(conn, :user, user)
    else
      conn
      |> put_flash(:warning, "User is not authenticated.")
      |> redirect(to: question_path(conn, :index))
      |> halt
    end
  end

  defp find_question(conn, _) do
    question = Repo.get_by!(Question, %{id: conn.params["id"]})
    assign(conn, :question, question)
  end

  defp authorize(conn, _) do
    if conn.assigns[:question].user_id != conn.assigns[:user].id do
      conn
      |> put_flash(:warning, "User is not authorized.")
      |> redirect(to: question_path(conn, :index))
      |> halt
    else
      conn
    end
  end

  defp current_user(conn) do
    user = Plug.Conn.get_session(conn, :current_user)
    if not is_nil(user) do
      Repo.get_by(User, %{id: user.id})
    end
    user
  end

end

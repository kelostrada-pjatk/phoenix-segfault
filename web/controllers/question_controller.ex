defmodule Segfault.QuestionController do
  use Segfault.Web, :controller

  alias Segfault.Question

  plug :scrub_params, "question" when action in [:create, :update]
  plug Segfault.Plugs.FindResource, %{resource: :question, type: Question} when action in [:show, :edit, :update, :delete]
  plug Segfault.Plugs.Authenticate when action in [:new, :create, :edit, :update, :delete]
  plug Segfault.Plugs.Authorize, :question when action in [:edit, :update, :delete]

  def index(conn, _params) do
    questions = Repo.all(from q in Question, preload: [:user])
    render(conn, "index.html", questions: questions)
  end

  def new(conn, _params) do
    changeset = Question.changeset(%Question{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"question" => question_params}) do
    user = conn.assigns[:current_user]
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

    questions = Repo.all from q in Question,
               left_join: us in assoc(q, :user),
               preload: [user: us],
               left_join: a in assoc(q, :answers),
               left_join: u in assoc(a, :user),
               where: q.id == ^id,
               preload: [answers: {a, user: u}]

    question = List.first(questions)

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

  #defp current_user(conn) do
  #  user = Plug.Conn.get_session(conn, :current_user)
  #  if not is_nil(user) do
  #    Repo.get_by(User, %{id: user.id})
  #  end
  #  user
  #end

end

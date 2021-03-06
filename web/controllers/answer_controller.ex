defmodule Segfault.AnswerController do
  use Segfault.Web, :controller

  alias Segfault.Answer
  alias Segfault.Question

  plug :scrub_params, "answer" when action in [:create, :update]
  plug Segfault.Plugs.FindResource, %{resource: :question, type: Question, key: "question_id"}
  plug Segfault.Plugs.FindResource, %{resource: :answer, type: Answer, dependency: :question} when action in [:show, :edit, :update, :delete]
  plug Segfault.Plugs.Authenticate when action in [:new, :create, :edit, :update, :delete]

  def index(conn, _params) do
    question_id = conn.assigns[:question].id
    answers = Repo.all from a in Answer,
              left_join: u in assoc(a, :user),
              where: a.question_id == ^question_id,
              preload: [user: u]
    render(conn, "index.html", answers: answers)
  end

  def new(conn, _params) do
    changeset = Answer.changeset(%Answer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"answer" => answer_params}) do
    changeset = Answer.changeset(%Answer{question_id: conn.assigns[:question].id, user_id: conn.assigns[:user].id}, answer_params)

    case Repo.insert(changeset) do
      {:ok, _answer} ->
        conn
        |> put_flash(:info, "Answer created successfully.")
        |> redirect(to: question_path(conn, :show, conn.assigns[:question]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _params) do
    answer = conn.assigns[:answer]
    answer = Repo.preload(answer, :user)
    render(conn, "show.html", answer: answer)
  end

  def edit(conn, _params) do
    answer = conn.assigns[:answer]
    changeset = Answer.changeset(answer)
    render(conn, "edit.html", answer: answer, changeset: changeset)
  end

  def update(conn, %{"answer" => answer_params}) do
    answer = conn.assigns[:answer]
    changeset = Answer.changeset(answer, answer_params)

    case Repo.update(changeset) do
      {:ok, answer} ->
        conn
        |> put_flash(:info, "Answer updated successfully.")
        |> redirect(to: question_answer_path(conn, :show, conn.assigns[:question], answer))
      {:error, changeset} ->
        render(conn, "edit.html", answer: answer, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    answer = conn.assigns[:answer]

    Repo.delete!(answer)

    conn
    |> put_flash(:info, "Answer deleted successfully.")
    |> redirect(to: question_answer_path(conn, :index, conn.assigns[:question]))
  end

end

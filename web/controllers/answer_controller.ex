defmodule Segfault.AnswerController do
  use Segfault.Web, :controller

  alias Segfault.Answer

  plug :scrub_params, "answer" when action in [:create, :update]
  plug :find_question

  def index(conn, _params) do
    answers = Repo.all(Answer)
    render(conn, "index.html", answers: answers)
  end

  def new(conn, _params) do
    changeset = Answer.changeset(%Answer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"answer" => answer_params}) do
    changeset = Answer.changeset(%Answer{question_id: conn.assigns[:question].id}, answer_params)

    case Repo.insert(changeset) do
      {:ok, _answer} ->
        conn
        |> put_flash(:info, "Answer created successfully.")
        |> redirect(to: question_path(conn, :show, conn.assigns[:question]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    answer = Repo.get!(Answer, id)
    render(conn, "show.html", answer: answer)
  end

  def edit(conn, %{"id" => id}) do
    answer = Repo.get!(Answer, id)
    changeset = Answer.changeset(answer)
    render(conn, "edit.html", answer: answer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "answer" => answer_params}) do
    answer = Repo.get!(Answer, id)
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

  def delete(conn, %{"id" => id}) do
    answer = Repo.get!(Answer, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(answer)

    conn
    |> put_flash(:info, "Answer deleted successfully.")
    |> redirect(to: question_answer_path(conn, :index, conn.assigns[:question]))
  end

  defp find_question(conn, _) do
    question = Repo.get_by!(Segfault.Question, %{id: conn.params["question_id"]})
    assign(conn, :question, question)
  end

end

defmodule Segfault.Answer do
  use Segfault.Web, :model

  schema "answers" do
    field :content, :string
    field :points, :integer
    belongs_to :question, Segfault.Question
    belongs_to :user, Segfault.User

    timestamps
  end

  @required_fields ~w(content)
  @optional_fields ~w(points)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> put_change(:points, 0)
  end
end

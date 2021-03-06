defmodule Segfault.Router do
  use Segfault.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Segfault.Plugs.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Segfault do
    pipe_through :browser # Use the default browser stack

    get "/", QuestionController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/questions", QuestionController do
      resources "/answers", AnswerController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Segfault do
  #   pipe_through :api
  # end
end

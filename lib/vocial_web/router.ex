defmodule VocialWeb.Router do
  use VocialWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VocialWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/polls", PollController, [:index, :new, :create, :show]
    resources "/users", UserController, [:new, :show, :create]
    resources "/sessions", SessionController, [:create]

    get "/login", SessionController, :new
    get "/logout", SessionController, :delete
    get "/options/:id/vote", PollController, :vote
  end

  # Other scopes may use custom stacks.
  # scope "/api", VocialWeb do
  #   pipe_through :api
  # end
end

defmodule TriviaWeb.Router do
  use TriviaWeb, :router

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

  scope "/", TriviaWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/games", GameController, only: [:create, :show], param: "name"
  end

  # Other scopes may use custom stacks.
  # scope "/api", TriviaWeb do
  #   pipe_through :api
  # end
end

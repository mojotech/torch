defmodule Example.Router do
  use Example.Web, :router

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

  scope "/", Example do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/admin", Example.Admin, as: :admin do
    pipe_through :browser

    resources "/posts", PostController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Example do
  #   pipe_through :api
  # end
end

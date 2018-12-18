defmodule MytubeWeb.Router do
  use MytubeWeb, :router

  pipeline :auth do
    plug MytubeWeb.Plugs.RequireAuth
  end
  
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MytubeWeb.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", MytubeWeb do
    pipe_through :browser

    get "/signout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :new
  end

  scope "/", MytubeWeb do
    pipe_through [:browser, :auth]

    resources "/videos", VideoController, only: [:new, :create]
  end
  
  scope "/", MytubeWeb do
    pipe_through :browser # Use the default browser stack
    resources "/videos", VideoController, only: [:index, :show, :delete, :update]
    get "/", PageController, :index
  end

end

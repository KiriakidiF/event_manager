defmodule EventManagerWeb.Router do
  use EventManagerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug EventManagerWeb.Plugs.FetchSession
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EventManagerWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/register", UserController, :register
    resources "/users", UserController
    resources "/events", EventController
    resources "/invites", InviteController
    resources "/comments", CommentController

    get "/users/photo/:id", UserController, :photo


    # Following Lecture code 11-photoblog
    resources "/sessions", SessionController,
      only: [:create, :delete], singleton: true
  end


  # Other scopes may use custom stacks.
  # scope "/api", EventManagerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: EventManagerWeb.Telemetry
    end
  end
end

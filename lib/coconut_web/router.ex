defmodule CoconutWeb.Router do
  use CoconutWeb, :router

  import CoconutWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CoconutWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :ensure_authenticated_user
  end

  scope "/", CoconutWeb do
    pipe_through [:browser, :auth]

    get "/", LeadController, :index
    post "/flatfile/auth", JwtController, :create
    # Need some way to pass secret in to prevent unauthenticated posts
    # post "/flatfile/webhook", WebhookController, :create
  end

  scope "/auth", CoconutWeb do
    pipe_through :browser

    get "/", AuthController, :index
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  scope "/api", CoconutWeb do
    pipe_through :api

    get "/countries", CountryController, :index
    get "/health", HealthCheckController, :index
  end

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

      live_dashboard "/dashboard", metrics: CoconutWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

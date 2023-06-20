defmodule ElixirSplitwiseWeb.Router do
  use ElixirSplitwiseWeb, :router

  import ElixirSplitwiseWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ElixirSplitwiseWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirSplitwiseWeb do
    pipe_through :browser
    get "/", PageController, :home
  end

  scope "/", ElixirSplitwiseWeb do
    pipe_through [:browser, :require_authenticated_user, :disable_app_layout]

    get "/add_friend", FriendshipController, :new
    post "/add_friend", FriendshipController, :create
  end

  scope "/", ElixirSplitwiseWeb.Live do
    pipe_through [:browser, :require_authenticated_user]
    live_session(:default) do
      live "/dashboard", Dashboard.DashboardLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirSplitwiseWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:elixir_splitwise, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ElixirSplitwiseWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", ElixirSplitwiseWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated, :disable_app_layout]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/register/:token", UserRegistrationController, :edit
    put "/users/register/:token", UserRegistrationController, :update
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", ElixirSplitwiseWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", ElixirSplitwiseWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end

  def disable_app_layout(conn, _opts) do
    conn
    |> put_layout(false)
  end
end

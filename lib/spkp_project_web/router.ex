defmodule SpkpProjectWeb.Router do
  use SpkpProjectWeb, :router

  import SpkpProjectWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SpkpProjectWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SpkpProjectWeb do
    pipe_through :browser

    live "/", LamanUtamaLive

    live "/mengenaikami", MengenaiKamiLive

    live "/programkursus", ProgramKursusLive

    live "/hubungi", HubungiLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", SpkpProjectWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:spkp_project, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SpkpProjectWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/admin", SpkpProjectWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_admin,
      on_mount: [{SpkpProjectWeb.UserAuth, {:ensure_role, "admin"}}] do
      live "/dashboard", AdminDashboardLive
      live "/permohonan", PermohonanLive
      live "/tetapan", TetapanLive

      live "/kursus", KursussLive.Index, :index
      live "/kursus/new", KursussLive.Index, :new
      live "/kursus/:id/edit", KursussLive.Index, :edit

      live "/kursus/:id", KursussLive.Show, :show
      live "/kursus/:id/show/edit", KursussLive.Show, :edit

      live "/kursus_kategori", KursusKategoriLive.Index, :index
      live "/kursus_kategori/new", KursusKategoriLive.Index, :new
      live "/kursus_kategori/:id/edit", KursusKategoriLive.Index, :edit

      live "/kursus_kategori/:id", KursusKategoriLive.Show, :show
      live "/kursus_kategori/:id/show/edit", KursusKategoriLive.Show, :edit

      live "/peserta/senaraipeserta", SenaraiPesertaLive

      live "/elaunpekerja/senaraituntutan", SenaraiTuntutanLive
      live "/elaunpekerja/buattuntutanbaru", BuatTuntutanBaruLive
      live "/elaunpekerja/senaraipekerja", SenaraiPekerjaLive

      live "/editprofile", EditProfileLive.Show
      live "/tetapan/tukarkatalaluan", TukarKataLaluanLive
    end
  end

  # Pekerja routes
  scope "/pekerja", SpkpProjectWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_pekerja,
      on_mount: [{SpkpProjectWeb.UserAuth, {:ensure_role, "pekerja"}}] do
      live "/dashboard", PekerjaDashboardLive
    end
  end

  scope "/", SpkpProjectWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{SpkpProjectWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/forgot_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", SpkpProjectWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{SpkpProjectWeb.UserAuth, :ensure_authenticated}] do

      # User dashboard & profile
      live "/userdashboard", UserDashboardLive, :dashboard
      live "/userprofile", UserProfileLive, :profile
      live "/senaraikursususer", SenaraiKursusLive, :courses
      live "/permohonanuser", PermohonanUserLive, :applications

      # User settings
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", SpkpProjectWeb do
    pipe_through [:browser]

    delete "/halamanutama", UserSessionController, :delete
    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{SpkpProjectWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new

      live "/lamanutama", LamanUtamaLive
    end
  end
end

defmodule SpkpProjectWeb.UserSessionController do
  use SpkpProjectWeb, :controller

  alias SpkpProject.Accounts
  alias SpkpProjectWeb.UserAuth

   # Login dengan _action (register, password_updated, dsb.)
   def create(conn, %{"_action" => action} = params) do
    case action do
      "registered" ->
        create(conn, params, "Akaun Berjaya Dibuat!")

      "password_updated" ->
        conn
        |> put_session(:user_return_to, ~p"/users/settings")
        |> create(params, "Kata Laluan Berjaya Di Kemaskini!")

      _ ->
        create(conn, params, "Selamat Kembali!")
    end
  end

  # Login biasa
  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> redirect(to: ~p"/users/log_in")

      user ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> UserAuth.log_in_user(user)   # login tanpa redirect
        |> redirect_user_by_role(user)  # controller tentukan redirect
    end
  end

  # 🔑 Helper login dengan flash tambahan
  defp create(conn, %{"user" => %{"email" => email, "password" => password}} = user_params, info) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> put_flash(:email, String.slice(email, 0, 160))
        |> redirect(to: ~p"/users/log_in")

      user ->
        conn
        |> put_flash(:info, info)
        |> UserAuth.log_in_user(user, user_params)
        |> redirect_user_by_role(user)  # redirect ikut role
    end
  end

  # Redirect ikut role
  defp redirect_user_by_role(conn, user) do
    case get_session(conn, :user_return_to) do
      nil ->
        case user.role do
          "admin"   -> redirect(conn, to: ~p"/admin/dashboard")
          "pekerja" -> redirect(conn, to: ~p"/pekerja/dashboard")
          "user"    -> redirect(conn, to: ~p"/userdashboard")
          _         -> redirect(conn, to: ~p"/")
        end

      return_to ->
        redirect(conn, to: return_to)
    end
  end

  # Logout
  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end

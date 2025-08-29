defmodule SpkpProjectWeb.UserSessionController do
  use SpkpProjectWeb, :controller

  alias SpkpProject.Accounts
  alias SpkpProjectWeb.UserAuth

  def create(conn, %{"_action" => action} = params) do
    case action do
      "registered" ->
        create(conn, params, "Account created successfully!")

      "password_updated" ->
        conn
        |> put_session(:user_return_to, ~p"/users/settings")
        |> create(params, "Password updated successfully!")

      _ ->
        create(conn, params, "Welcome back!")
    end
  end

  # Create: Login biasa
  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> redirect(to: ~p"/users/log_in")

      user ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> UserAuth.log_in_user(user)
        |> redirect_user_by_role(user)
    end
  end

  # Create: Fungsi helper jika ada info tambahan (contoh flash message)
  defp create(
         conn,
         %{"user" => %{"email" => email, "password" => password}} =
           user_params,
         info
       ) do
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
        |> redirect_user_by_role(user)
    end
  end

  # Redirect berdasarkan role user
  defp redirect_user_by_role(conn, user) do
    case user.role do
      "admin" -> redirect(conn, to: ~p"/admin/dashboard")
      "user" -> redirect(conn, to: ~p"/userdashboard")
      _ -> redirect(conn, to: ~p"/")
    end
  end

  # Logout
  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end

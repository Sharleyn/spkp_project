defmodule SpkpProjectWeb.UserSettingsLive do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Accounts

  ## Mount
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    {:ok,
     socket
     |> assign(:email_form, to_form(%{"email" => user.email}, as: "user"))
     |> assign(:password_form, to_form(%{}, as: "user"))
     |> assign(
       :form,
       to_form(
         %{
           "email" => user.email,
           "password" => "",
           "password_confirmation" => ""
         },
         as: "user"
       )
     )}
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end


  ## Render
  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center min-h-screen bg-gray-50">
      <div class="w-full max-w-xl bg-white rounded-2xl shadow p-8 space-y-6">
        <!-- Header -->
        <div class="flex flex-col items-center">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="w-20 h-20 text-gray-800"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
            />
          </svg>
          <h2 class="mt-4 text-2xl font-bold">Tetapan Pengguna</h2>

          <p class="text-sm text-center text-gray-700">
            Sila masukkan email atau kata laluan baru anda untuk dikemaskini.
          </p>
        </div>
        <!-- Form Update Email -->
        <.simple_form for={@email_form} id="email_form" phx-submit="update_email">
          <.input field={@email_form[:email]} type="email" label="Email Baru" required />
          <.input field={@email_form[:current_password]} type="password" label="Kata Laluan" required />
          <:actions>
            <button
              type="submit"
              class="px-4 py-2 font-medium bg-blue-500 text-white rounded-lg hover:bg-blue-700"
            >
              Simpan Email
            </button>
          </:actions>
        </.simple_form>
         <hr class="my-6" />
        <!-- Form Update Password -->
        <.simple_form for={@password_form} id="password_form" phx-submit="update_password">
          <.input
            field={@password_form[:current_password]}
            type="password"
            label="Kata Laluan"
            required
          />
          <.input field={@password_form[:password]} type="password" label="Kata Laluan Baru" required />
          <.input
            field={@password_form[:password_confirmation]}
            type="password"
            label="Pengesahan Kata Laluan Baru"
            required
          />
          <:actions>
            <div class="mt-6 relative w-full flex justify-center items-center">
              <!-- Button Simpan (absolutely left) -->
              <button
                type="submit"
                class="absolute left-0 px-4 py-2 font-medium bg-blue-500 text-white rounded-lg hover:bg-blue-700"
              >
                Simpan Kata Laluan
              </button>
              <!-- Button Balik (absolutely right) -->
              <.link
                navigate={~p"/userdashboard"}
                class="absolute right-0 px-4 py-2 bg-gray-500 font-medium text-white rounded-lg hover:bg-gray-600"
              >
                Balik ke Laman Utama
              </.link>
            </div>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end
  ## Handle update email
  def handle_event("update_email", %{"user" => user_params}, socket) do
    current_password = user_params["current_password"]

    case Accounts.apply_user_email(socket.assigns.current_user, current_password, user_params) do
      {:ok, _applied_user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Check your inbox for a confirmation link.")
         |> assign(
           :email_form,
           to_form(%{"email" => socket.assigns.current_user.email}, as: "user")
         )}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(changeset, as: "user"))}
    end
  end

  ## Handle update password
  def handle_event("update_password", %{"user" => user_params}, socket) do
    current_password = user_params["current_password"]

    case Accounts.update_user_password(socket.assigns.current_user, current_password, user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password updated successfully.")
         |> assign(:current_user, user)
         |> assign(:password_form, to_form(%{}, as: "user"))}

      {:error, changeset} ->
        {:noreply, assign(socket, :password_form, to_form(changeset, as: "user"))}
    end
  end

  ## Handle validate (umum)
  def handle_event("validate", %{"user" => params}, socket) do
    {:noreply, assign(socket, form: to_form(params, as: "user"))}
  end

  ## Handle save (umum)
  def handle_event("save", %{"user" => params}, socket) do
    user = socket.assigns.current_user

    case Accounts.update_user(user, params) do
      {:ok, _updated_user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tetapan berjaya disimpan.")
         |> push_navigate(to: ~p"/userdashboard")}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset, as: "user"))}
    end
  end
end

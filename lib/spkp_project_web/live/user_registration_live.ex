defmodule SpkpProjectWeb.UserRegistrationLive do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Accounts
  alias SpkpProject.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center min-h-screen bg-gray-50">
      <div class="w-full max-w-md bg-white rounded-2xl shadow p-8 space-y-6">

        <!-- Avatar -->
        <div class="flex flex-col items-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-20 h-20 text-gray-800" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
          </svg>
          <h2 class="mt-4 text-2xl font-bold">Daftar Akaun</h2>
          <p class="text-sm text-gray-600">Cipta Akaun Baharu Untuk Mengakses Sistem Kursus</p>
        </div>

        <!-- Form -->
        <.form for={@form} id="registration_form" phx-submit="save" phx-change="validate">
          <!-- Nama Penuh -->
          <div>
            <label class="block text-sm font-semibold">Nama Penuh</label>
            <.input field={@form[:full_name]} type="text" placeholder="Masukkan nama penuh" class="mt-1 w-full" required />
            <p class="text-xs text-gray-400">* seperti dalam Kad Pengenalan</p>
          </div>

          <!-- Email -->
          <div class="mt-4">
            <label class="block text-sm font-semibold">Email</label>
            <.input field={@form[:email]} type="email" placeholder="contoh@email.com" class="mt-1 w-full" required />
          </div>

          <!-- Kata Laluan -->
          <div class="mt-4 relative">
            <label class="block text-sm font-semibold">Kata Laluan</label>
            <.input field={@form[:password]} type="password" placeholder="Masukkan kata laluan" class="mt-1 w-full pr-10" required />
            <button type="button" phx-click="toggle_password" class="absolute right-3 top-8 text-gray-500">
            </button>
          </div>

          <!-- Sah Kata Laluan -->
          <div class="mt-4 relative">
            <label class="block text-sm font-semibold">Sahkan Kata Laluan</label>
            <.input field={@form[:password_confirmation]} type="password" placeholder="Sahkan kata laluan" class="mt-1 w-full pr-10" required />
            <button type="button" phx-click="toggle_password" class="absolute right-3 top-8 text-gray-500">
            </button>
          </div>

          <!-- Button -->
          <div class="mt-6">
            <.button type="submit" class="w-full bg-blue-500 hover:bg-blue-600 text-white py-2 rounded-lg font-semibold">
              Daftar Akaun
            </.button>
          </div>
        </.form>

        <!-- Link ke login -->
        <div class="bg-gray-100 py-3 text-center rounded-lg">
          Sudah Mempunyai Akaun?
          <.link navigate={~p"/users/log_in"} class="font-bold text-blue-600 hover:underline">
            Log Masuk Di Sini
          </.link>
        </div>

      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

          {:noreply,
          socket
          |> put_flash(:info, "Pendaftaran berjaya! Sila log masuk.")
          |> push_navigate(to: ~p"/users/log_in")}
     end
   end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end

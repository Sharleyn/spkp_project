defmodule SpkpProjectWeb.UserForgotPasswordLive do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Accounts

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center min-h-screen bg-gray-50">
      <div class="w-full max-w-md bg-white rounded-2xl shadow p-8 space-y-6">
        <!-- Avatar -->
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
          <h2 class="mt-4 text-2xl font-bold">Lupa Kata Laluan</h2>
          
          <p class="text-sm text-gray-600">Masukkan kata laluan baru anda untuk mengakses sistem</p>
        </div>
        <!-- Form -->
        <.form for={@form} id="forgot_password_form" phx-submit="save" phx-change="validate">
          <!-- Email -->
          <div class="mt-4">
            <label class="block text-sm font-semibold">Email</label>
            <.input
              field={@form[:email]}
              type="email"
              placeholder="contoh@email.com"
              class="mt-1 w-full"
              required
            />
          </div>
          <!-- Kata Laluan -->
          <div class="mt-4 relative">
            <label class="block text-sm font-semibold">Kata Laluan</label>
            <.input
              field={@form[:password]}
              type="password"
              placeholder="Masukkan kata laluan"
              class="mt-1 w-full pr-10"
              required
            />
            <button
              type="button"
              phx-click="toggle_password"
              class="absolute right-3 top-8 text-gray-500"
            >
            </button>
          </div>
          <!-- Sah Kata Laluan -->
          <div class="mt-4 relative">
            <label class="block text-sm font-semibold">Sahkan Kata Laluan</label>
            <.input
              field={@form[:password_confirmation]}
              type="password"
              placeholder="Sahkan kata laluan"
              class="mt-1 w-full pr-10"
              required
            />
            <button
              type="button"
              phx-click="toggle_password"
              class="absolute right-3 top-8 text-gray-500"
            >
            </button>
          </div>
          <!-- Button -->
          <div class="mt-6">
            <.button
              type="submit"
              class="w-full bg-blue-500 hover:bg-blue-600 text-white py-2 rounded-lg font-semibold"
            >
              Log Masuk
            </.button>
          </div>
        </.form>
        <!-- Link ke Daftar Akaun -->
        <div class="bg-gray-100 py-3 text-center rounded-lg">
          Belum  Mempunyai Akaun?
          <.link navigate={~p"/users/register"} class="font-bold text-blue-600 hover:underline">
            Daftar Di Sini
          </.link>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end

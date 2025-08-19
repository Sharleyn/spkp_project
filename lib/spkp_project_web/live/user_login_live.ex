defmodule SpkpProjectWeb.UserLoginLive do
  use SpkpProjectWeb, :live_view

  alias SpkpProjectWeb.Accounts
  alias SpkpProjectWeb.UserAuth

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center min-h-screen bg-gray-50">
      <div class="w-full max-w-md bg-white rounded-2xl shadow p-8 space-y-6">

        <!-- Avatar -->
        <div class="flex flex-col items-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-20 h-20 text-gray-800" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
          </svg>
          <h2 class="mt-4 text-2xl font-bold">Log Masuk</h2>
          <p class="text-sm text-gray-600">Masukkan maklumat akaun anda untuk mengakses sistem</p>
        </div>

        <!-- Form - menggunakan regular form untuk POST ke controller -->
        <form action={~p"/users/log_in"} method="post" id="login_form">
          <input type="hidden" name="_csrf_token" value={Phoenix.Controller.get_csrf_token()} />

          <!-- Email -->
          <div class="mt-4">
            <label class="block text-sm font-semibold">Email</label>
            <input type="email" name="user[email]" placeholder="contoh@email.com" class="mt-1 w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" required />
          </div>

          <!-- Kata Laluan -->
          <div class="mt-4 relative">
            <label class="block text-sm font-semibold">Kata Laluan</label>
            <input type="password" name="user[password]" placeholder="Masukkan kata laluan" class="mt-1 w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent pr-10" required />
          </div>

          <!-- Button -->
          <div class="mt-6">
            <button type="submit" class="w-full bg-blue-500 hover:bg-blue-600 text-white py-2 rounded-lg font-semibold">
              Log Masuk
            </button>
          </div>
        </form>

        <!-- Link ke Daftar Akaun -->
        <div class="bg-gray-100 py-3 text-center rounded-lg">
          Belum  Mempunyai Akaun?
          <.link navigate={~p"/users/register"} class="font-bold text-blue-600 hover:underline">
            Daftar Di Sini
          </.link>
        </div>

        <!-- Link Lupa Kata Laluan -->
        <div class="bg-gray-100 py-3 text-center rounded-lg">
          <.link navigate={~p"/users/forgot_password"} class="font-bold text-blue-600 hover:underline">
            Lupa Kata Laluan?
          </.link>
        </div>

      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    {:ok, assign(socket, email: email)}
  end
end

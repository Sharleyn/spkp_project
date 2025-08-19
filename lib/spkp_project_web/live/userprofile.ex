defmodule SpkpProjectWeb.UserProfileLive do
  use SpkpProjectWeb, :live_view

  def mount(_params, _session, socket) do
    # Contoh: dapatkan user dari assigns kalau dah login
    {:ok, assign(socket, :user, %{name: "Ali Bin Abu", email: "ali@example.com"})}
  end

  def render(assigns) do
    ~H"""

    <div class="max-w-xl mx-auto mt-10 bg-white shadow-md rounded-2xl p-6 space-y-4">
      <h2 class="text-2xl font-bold text-gray-700">Profil Pengguna</h2>

      <div class="space-y-2">
        <p><span class="font-semibold">Nama:</span> <%= @user.name %></p>
        <p><span class="font-semibold">Email:</span> <%= @user.email %></p>
      </div>

      <div class="pt-4">
        <.link navigate={~p"/userdashboard"} class="inline-block px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
          ← Kembali ke Dashboard
        </.link>
      </div>
    </div>

    """
  end
end

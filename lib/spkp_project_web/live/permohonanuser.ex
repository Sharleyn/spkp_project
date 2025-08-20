defmodule SpkpProjectWeb.PermohonanUserLive do
  use SpkpProjectWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-2xl font-bold">Permohonan Saya</h1>
      <p class="mt-4 text-gray-600">Ini halaman permohonan pengguna.</p>
    </div>

    <div class="pt-6">
        <.link navigate={~p"/userdashboard"} class="inline-block px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
          ← Kembali ke Dashboard
        </.link>
      </div>
    """
  end
end

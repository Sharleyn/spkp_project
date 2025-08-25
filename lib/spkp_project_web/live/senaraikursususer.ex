defmodule SpkpProjectWeb.SenaraiKursusLive do
  use SpkpProjectWeb, :live_view

  def mount(_params, _session, socket) do
    # Contoh data kursus user (nanti boleh tarik dari DB Reservation/Course)
    courses = [
      %{id: 1, title: "Kursus Elixir & Phoenix", status: "Disahkan"},
      %{id: 2, title: "Kursus Tailwind CSS", status: "Dalam Proses"},

    ]

    {:ok, assign(socket, :courses, courses)}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto mt-10 bg-white shadow-md rounded-2xl p-6">
      <h2 class="text-2xl font-bold text-gray-700 mb-4">📚 Senarai Kursus Saya</h2>

      <table class="w-full text-left border-collapse">
        <thead>
          <tr class="bg-gray-100 text-gray-700">
            <th class="p-3">#</th>
            <th class="p-3">Nama Kursus</th>
            <th class="p-3">Status</th>
          </tr>
        </thead>
        <tbody>
          <%= for course <- @courses do %>
            <tr class="border-b hover:bg-gray-50">
              <td class="p-3"><%= course.id %></td>
              <td class="p-3"><%= course.title %></td>
              <td class="p-3">
                <span class={
                  case course.status do
                    "Disahkan" -> "text-green-600 font-semibold"
                    "Dalam Proses" -> "text-yellow-600 font-semibold"
                    "Ditolak" -> "text-red-600 font-semibold"
                    _ -> "text-gray-600"
                  end
                }>
                  <%= course.status %>
                </span>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>

      <div class="pt-6">
        <.link navigate={~p"/userdashboard"} class="inline-block px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
          ← Kembali ke Dashboard
        </.link>
      </div>
    </div>
    """
  end
end

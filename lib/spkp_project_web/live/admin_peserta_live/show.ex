defmodule SpkpProjectWeb.AdminKategoriLive.Show do
  use SpkpProjectWeb, :live_view
  alias SpkpProject.Kursus.KursusKategori
  alias SpkpProject.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    kategori =
      KursusKategori
      |> Repo.get!(id)
      |> Repo.preload(:kursus)

    {:noreply,
     socket
     |> assign(:kategori, kategori)
     |> assign(:page_title, "Kategori: #{kategori.kategori}")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-2xl font-bold mb-6">Kategori: <%= @kategori.kategori %></h1>

      <!-- Table Senarai Kursus -->
      <div class="bg-white shadow rounded-lg overflow-hidden">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-100">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nama Kursus</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tarikh</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tempat</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Kaedah</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <%= for kursus <- @kategori.kursus do %>
              <tr class="hover:bg-gray-50">
              <td class="px-6 py-4 text-sm text-gray-900 font-medium">
                <.link navigate={~p"/admin/kursus/#{kursus.id}/peserta"} class="text-blue-600 hover:underline">
                  <%= kursus.nama_kursus %>
                </.link>
              </td>


                <td class="px-6 py-4 text-sm text-gray-500">
                  <%= Calendar.strftime(kursus.tarikh_mula, "%d-%m-%Y") %> →
                  <%= Calendar.strftime(kursus.tarikh_akhir, "%d-%m-%Y") %>
                </td>
                <td class="px-6 py-4 text-sm text-gray-500"><%= kursus.tempat %></td>
                <td class="px-6 py-4 text-sm text-gray-500"><%= kursus.kaedah %></td>
                <td class="px-6 py-4">
                  <span class={
                    case kursus.status_kursus do
                      "Buka" -> "px-2 py-1 text-xs rounded bg-green-100 text-green-800"
                      "Tutup" -> "px-2 py-1 text-xs rounded bg-red-100 text-red-800"
                      "Tamat" -> "px-2 py-1 text-xs rounded bg-yellow-100 text-yellow-800"
                      _ -> "px-2 py-1 text-xs rounded bg-yellow-100 text-yellow-800"
                    end
                  }>
                    <%= kursus.status_kursus %>
                  </span>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>

      <!-- Button kembali -->
      <div class="mt-6">
        <.link navigate={~p"/admin/peserta"} class="bg-gray-600 text-white px-4 py-2 rounded">
          ← Kembali
        </.link>
      </div>
    </div>
    """
  end
end

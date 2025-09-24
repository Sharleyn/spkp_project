defmodule SpkpProjectWeb.AdminKategoriLive.Show do
  use SpkpProjectWeb, :live_view
  alias SpkpProject.Kursus.KursusKategori
  alias SpkpProject.Repo

  @impl true
  def mount(_params, _session, socket) do
    role = socket.assigns.current_user.role
    {:ok, assign(socket, :role, role)}
  end

  @impl true
  def handle_params(%{"id" => id} = _params, uri, socket) do
    kategori =
      KursusKategori
      |> Repo.get!(id)
      |> Repo.preload(:kursus)

    current_path =
      uri
      |> URI.parse()
      |> Map.get(:path)

    {:noreply,
     socket
     |> assign(:kategori, kategori)
     |> assign(:page_title, "Kategori: #{kategori.kategori}")
     |> assign(:current_path, current_path)}
  end

  # helper: generate kursus -> peserta path and include kategori_id as query param
  defp kursus_peserta_path("admin", kursus_id, kategori_id),
    do: ~p"/admin/kursus/#{kursus_id}/peserta?#{[kategori_id: kategori_id]}"

  defp kursus_peserta_path("pekerja", kursus_id, kategori_id),
    do: ~p"/pekerja/kursus/#{kursus_id}/peserta?#{[kategori_id: kategori_id]}"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full min-h-screen bg-gray-100 flex">
      <!-- Sidebar -->
      <.live_component
        module={SpkpProjectWeb.SidebarComponent}
        id="sidebar"
        role={@current_user.role}
        current_user={@current_user}
        current_path={@current_path}
      />

      <!-- Main Content -->
      <div class="flex-1 flex flex-col">
        <.header class="bg-white shadow-sm border-b border-gray-200">
          <div class="flex justify-between items-center px-6 py-4">
            <div class="flex items-center space-x-4">
              <img src={~p"/images/a3.png"} alt="Logo" class="h-12" />
              <h1 class="text-xl font-semibold text-gray-800"><%= if @role == "admin", do: "SPKP Admin Dashboard", else: "SPKP Pekerja Dashboard" %></h1>
            </div>

            <div class="flex items-center space-x-4">
              <span class="text-gray-600"><%= @current_user.full_name %></span>
              <.link href={~p"/users/log_out"} method="delete" class="text-gray-600 hover:text-gray-800">Logout</.link>
              <div class="w-8 h-8 bg-gray-300 rounded-full"></div>
            </div>
          </div>
        </.header>

        <!-- Page Content -->
        <div class="flex-1 p-6">
          <div class="mb-6">
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Maklumat Permohonan</h1>
            <p class="text-sm text-gray-600 mb-2">Lihat maklumat permohonan kursus</p>
          </div>

          <div class="p-6">
            <h1 class="text-2xl font-bold mb-6">Kategori: <%= @kategori.kategori %></h1>

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
                        <.link navigate={kursus_peserta_path(@role, kursus.id, @kategori.id)} class="text-blue-600 hover:underline">
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
                        <span class={case kursus.status_kursus do
                          "Buka" -> "px-2 py-1 text-xs rounded bg-green-100 text-green-800"
                          "Tutup" -> "px-2 py-1 text-xs rounded bg-red-100 text-red-800"
                          "Tamat" -> "px-2 py-1 text-xs rounded bg-yellow-100 text-yellow-800"
                          _ -> "px-2 py-1 text-xs rounded bg-gray-100 text-gray-800"
                        end}>
                          <%= kursus.status_kursus %>
                        </span>
                      </td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>

            <div class="mt-6">
              <.link navigate={if @role == "admin", do: ~p"/admin/peserta", else: ~p"/pekerja/peserta"} class="bg-gray-600 text-white px-4 py-2 rounded">
                ← Kembali
              </.link>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end

defmodule SpkpProjectWeb.PesertaKursusLive.Show do
  use SpkpProjectWeb, :live_view
  import Ecto.Query, warn: false   # <-- Tambah baris ni
  alias SpkpProject.Repo
  alias SpkpProject.Userpermohonan.Userpermohonan
  alias SpkpProject.Kursus.Kursuss

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
def handle_params(%{"id" => id}, uri, socket) do
  kursus =
    Repo.get!(Kursuss, String.to_integer(id))
    |> Repo.preload(:kursus_kategori)

  peserta =
    from(p in Userpermohonan,
      where: p.kursus_id == ^kursus.id and p.status == "Diterima",
      preload: [:user]
    )
    |> Repo.all()

  current_path =
    uri
    |> URI.parse()
    |> Map.get(:path)

  {:noreply,
   socket
   |> assign(:peserta, peserta)
   |> assign(:kursus, kursus)
   |> assign(:kategori_id, kursus.kursus_kategori_id)
   |> assign(:current_path, current_path)
   |> assign(:page_title, "Peserta Diterima")}
end


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
            <h1 class="text-xl font-semibold text-gray-800">SPKP Admin Dashboard</h1>
          </div>

          <div class="flex items-center space-x-4">
            <span class="text-gray-600">admin@gmail.com</span>
            <.link href={~p"/users/log_out"} method="delete" class="text-gray-600 hover:text-gray-800">
              Logout
            </.link>
            <div class="w-8 h-8 bg-gray-300 rounded-full"></div>
          </div>
        </div>
      </.header>

      <!-- Page Content -->
      <div class="flex-1 p-6">
        <!-- Page Title -->
        <div class="mb-6">
          <h1 class="text-4xl font-bold text-gray-900 mb-2">Maklumat Permohonan</h1>
          <p class="text-sm text-gray-600 mb-2">Lihat maklumat permohonan kursus</p>
        </div>

        <div class="p-6">
          <h1 class="text-2xl font-bold mb-6">Senarai Peserta Diterima</h1>

          <div class="bg-white shadow rounded-lg overflow-hidden">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-100">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nama</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Email</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tarikh Permohonan</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <%= if @peserta == [] do %>
                  <tr>
                    <td colspan="3" class="px-6 py-4 text-center text-sm text-gray-500">
                      Tiada peserta diterima lagi untuk kursus ini.
                    </td>
                  </tr>
                <% else %>
                  <%= for p <- @peserta do %>
                    <tr class="hover:bg-gray-50">
                      <td class="px-6 py-4 text-sm text-gray-900"><%= p.user.full_name %></td>
                      <td class="px-6 py-4 text-sm text-gray-500"><%= p.user.email %></td>
                      <td class="px-6 py-4 text-sm text-gray-500">
                        <%= Calendar.strftime(p.inserted_at, "%d-%m-%Y") %>
                      </td>
                    </tr>
                  <% end %>
                <% end %>
              </tbody>
            </table>
          </div>

          <!-- Button Kembali -->
          <div class="mt-6">
            <.link navigate={~p"/admin/kategori/#{@kategori_id}"} class="bg-gray-600 text-white px-4 py-2 rounded">
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

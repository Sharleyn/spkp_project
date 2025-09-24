defmodule SpkpProjectWeb.DashboardLive do
  use SpkpProjectWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # Role datang dari UserAuth
    role = socket.assigns.current_user.role

    {:ok,
     socket
     |> assign(:role, role)
     |> assign(:current_path, socket.assigns[:uri] && URI.parse(socket.assigns.uri).path || "/")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full min-h-screen bg-gray-100 flex">
      <!-- Sidebar -->
      <.live_component
        module={SpkpProjectWeb.SidebarComponent}
        id="sidebar"
        current_view={@socket.view}
        role={@current_user.role}
        current_user={@current_user}
        current_path={@current_path}
      />

      <!-- Main Content -->
      <div class="flex-1 flex flex-col">
        <.header class="bg-white shadow-sm border-b border-gray-200">
          <div class="flex justify-between items-center px-6 py-4">
            <div class="flex items-center space-x-4">
              <div class="flex items-center gap-4">
                <img src={~p"/images/a3.png"} alt="Logo" class="h-12" />
              </div>

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

        <!-- Quick Actions -->
        <.quick_actions role={@role} />

        <!-- Statistik -->
        <.statistics />

        <!-- Jadual -->
        <.latest_registrations />
      </div>
    </div>
    """
  end

  ## COMPONENTS

  ## COMPONENTS

  defp quick_actions(assigns) do
    ~H"""
    <div class="mb-8 p-6">
      <div class="flex items-center space-x-2 mb-4">
        <svg class="w-6 h-6 text-gray-600 shrink-0" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" clip-rule="evenodd"
            d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0
            00-1.414-1.414L9 10.586 7.707 9.293a1 1 0
            00-1.414 1.414l2 2a1 1 0
            001.414 0l4-4z" />
        </svg>
        <h3 class="text-xl font-semibold text-gray-800">Tindakan pantas</h3>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Box 1 -->
        <div class="bg-white border rounded-lg p-6 hover:shadow-md cursor-pointer overflow-hidden">
          <.link patch={~p"/admin/kursus/new?return_to=/admin/dashboard"} class="block">
            <div class="flex flex-wrap items-center justify-between min-w-0">
              <div class="min-w-0 break-words">
                <h4 class="font-semibold text-gray-800 mb-2">Tambah kursus baru</h4>
                <p class="text-gray-600 text-sm">Cipta kursus baru untuk peserta</p>
              </div>
              <img src={~p"/images/users.png"} alt="Peserta"
                class="w-8 h-8 object-contain flex-shrink-0 max-w-full" />
            </div>
          </.link>
        </div>

        <!-- Box 2 (hanya untuk admin) -->
        <%= if @role == "admin" do %>
          <.link navigate={~p"/admin/permohonan"} class="block">
            <div class="bg-white border rounded-lg p-6 hover:shadow-md cursor-pointer overflow-hidden">
              <div class="flex flex-wrap items-center justify-between min-w-0">
                <div class="min-w-0 break-words">
                  <h4 class="font-semibold text-gray-800 mb-2">Pengesahan permohonan</h4>
                  <p class="text-gray-600 text-sm">Semak dan sahkan permohonan baru</p>
                </div>
                <img src={~p"/images/sah.png"} alt="Pengesahan"
                  class="w-8 h-8 object-contain flex-shrink-0 max-w-full" />
              </div>
            </div>
          </.link>
        <% end %>

          <!-- Box 3 -->
          <.link navigate={~p"/admin/peserta"} class="block">
            <div class="bg-white border rounded-lg p-6 hover:shadow-md cursor-pointer overflow-hidden">
              <div class="flex flex-wrap items-center justify-between min-w-0">
                <div class="min-w-0 break-words">
                  <h4 class="font-semibold text-gray-800 mb-2">Senarai peserta</h4>
                  <p class="text-gray-600 text-sm">Senarai peserta yang mengikuti kursus</p>
                </div>
                <img src={~p"/images/usershijauu.png"} alt="SenaraiPeserta"
                  class="w-8 h-8 object-contain flex-shrink-0 max-w-full" />
              </div>
            </div>
          </.link>

      </div>
    </div>
    """
  end


defp statistics(assigns) do
  ~H"""
  <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-6 px-6 mb-8">
    <!-- Stat Box 1 -->
    <div class="bg-white rounded-lg p-6 shadow-sm border overflow-hidden">
      <div class="flex flex-wrap items-center justify-between w-full px-4 min-w-0">
        <img src={~p"/images/users.png"} alt="Peserta"
          class="w-10 h-10 object-contain flex-shrink-0 max-w-full" />
        <div class="flex flex-col items-center min-w-0 break-words">
          <h4 class="text-sm text-gray-600">Jumlah peserta</h4>
          <div class="text-3xl font-bold text-gray-900">2300</div>
        </div>
      </div>
    </div>

    <!-- Stat Box 2 -->
    <div class="bg-white rounded-lg p-6 shadow-sm border overflow-hidden">
      <div class="flex flex-wrap items-center justify-between w-full px-4 min-w-0">
        <img src={~p"/images/buku.png"} alt="Kursus"
          class="w-10 h-10 object-contain flex-shrink-0 max-w-full" />
        <div class="flex flex-col items-center min-w-0 break-words">
          <h4 class="text-sm text-gray-600">Kursus Tersedia</h4>
          <div class="text-3xl font-bold text-gray-900">20</div>
        </div>
      </div>
    </div>

    <!-- Stat Box 3 -->
    <div class="bg-white rounded-lg p-6 shadow-sm border overflow-hidden">
      <div class="flex flex-wrap items-center justify-between w-full px-4 min-w-0">
        <img src={~p"/images/tickuser.png"} alt="Pendaftaran"
          class="w-10 h-10 object-contain flex-shrink-0 max-w-full" />
        <div class="flex flex-col items-center min-w-0 break-words">
          <h4 class="text-sm text-gray-600">Pendaftaran Baharu</h4>
          <div class="text-3xl font-bold text-gray-900">132</div>
        </div>
      </div>
    </div>

    <!-- Stat Box 4 -->
    <div class="bg-white rounded-lg p-6 shadow-sm border overflow-hidden">
      <div class="flex flex-wrap items-center justify-between w-full px-4 min-w-0">
        <img src={~p"/images/sijil.png"} alt="KadarTamat"
          class="w-10 h-10 object-contain flex-shrink-0 max-w-full" />
        <div class="flex flex-col items-center min-w-0 break-words">
          <h4 class="text-sm text-gray-600">Kadar Tamat</h4>
          <div class="text-3xl font-bold text-gray-900">98%</div>
        </div>
      </div>
    </div>
  </div>
  """
end


  defp latest_registrations(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-sm border mx-6 mb-8 overflow-x-auto">
      <div class="p-6 border-b border-gray-200">
        <h3 class="text-xl font-semibold text-gray-800">Jumlah Pendaftaran terkini</h3>
      </div>

      <table class="w-full min-w-max">
        <thead class="bg-gray-50">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Kursus</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Jumlah</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tarikh tamat</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <tr>
            <td class="px-6 py-4 text-sm">Web Development Bootcamp</td>
            <td class="px-6 py-4 text-sm">9</td>
            <td class="px-6 py-4 text-sm">30.06.2025</td>
          </tr>
          <tr>
            <td class="px-6 py-4 text-sm">Solekan</td>
            <td class="px-6 py-4 text-sm">8</td>
            <td class="px-6 py-4 text-sm">30.07.2025</td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end

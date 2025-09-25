defmodule SpkpProjectWeb.DashboardLive do
  use SpkpProjectWeb, :live_view
  alias SpkpProject.Repo

  @impl true
  def mount(_params, _session, socket) do
    role = socket.assigns.current_user.role

    # jumlah peserta diterima
    {:ok, %{rows: [[jumlah_peserta]]}} =
      Repo.query("SELECT COUNT(*) FROM userpermohonan WHERE status = 'Diterima'")

    # jumlah kursus
    {:ok, %{rows: [[jumlah_kursus]]}} =
      Repo.query("SELECT COUNT(*) FROM kursus")

    # jumlah pendaftaran baru
    {:ok, %{rows: [[jumlah_pendaftaran_baru]]}} =
      Repo.query("SELECT COUNT(*) FROM userpermohonan WHERE status = 'Dalam Proses'")

    # jumlah tamat
    {:ok, %{rows: [[jumlah_tamat]]}} =
      Repo.query("SELECT COUNT(*) FROM userpermohonan WHERE status = 'Tamat'")

    kadar_tamat =
      if jumlah_peserta > 0 do
        Float.round(jumlah_tamat / jumlah_peserta * 100, 1)
      else
        0
      end

    {:ok,
     socket
     |> assign(:role, role)
     |> assign(:jumlah_peserta, jumlah_peserta)
     |> assign(:jumlah_kursus, jumlah_kursus)
     |> assign(:jumlah_pendaftaran_baru, jumlah_pendaftaran_baru)
     |> assign(:kadar_tamat, kadar_tamat)
     |> assign(:latest_registrations, [])
     |> assign(:current_path, "/")}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    summary = SpkpProject.Userpermohonan.list_latest_applications_summary(5)

    {:noreply,
     socket
     |> assign(:current_path, URI.parse(uri).path)
     |> assign(:latest_registrations, summary)}
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
              <img src={~p"/images/a3.png"} alt="Logo" class="h-12" />
              <h1 class="text-xl font-semibold text-gray-800"><%= if @role == "admin", do: "SPKP Admin Dashboard", else: "SPKP Pekerja Dashboard" %></h1>
            </div>

            <div class="flex items-center space-x-4">
              <span class="text-gray-600"><%= @current_user.full_name%></span>
              <.link href={~p"/users/log_out"} method="delete" class="text-gray-600 hover:text-gray-800">
                Logout
              </.link>
            </div>
          </div>
        </.header>

        <!-- Quick Actions -->
        <.quick_actions role={@role} />

        <!-- Statistik -->
        <.statistics
          jumlah_peserta={@jumlah_peserta}
          jumlah_kursus={@jumlah_kursus}
          jumlah_pendaftaran_baru={@jumlah_pendaftaran_baru}
          kadar_tamat={@kadar_tamat}
        />

        <!-- Jadual -->
        <.latest_registrations latest_registrations={@latest_registrations} />
      </div>
    </div>
    """
  end

  # === COMPONENTS ===

  defp quick_actions(assigns) do
    ~H"""
    <div class="mb-8 p-6">
      <h3 class="text-xl font-semibold text-gray-800 mb-4 flex items-center gap-2">
        <svg class="w-6 h-6 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" clip-rule="evenodd"
            d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0
            00-1.414-1.414L9 10.586 7.707 9.293a1 1 0
            00-1.414 1.414l2 2a1 1 0
            001.414 0l4-4z" />
        </svg>
        Tindakan pantas
      </h3>

      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Box 1 - Tambah Kursus -->
        <div class="bg-white border border-gray-200 border-l-4 border-l-blue-300 rounded-xl p-6 hover:shadow-md transition-all duration-200 cursor-pointer group">
          <.link patch={if @role == "admin", do: ~p"/admin/kursus/new?return_to=/admin/dashboard", else: ~p"/pekerja/kursus/new?return_to=/pekerja/dashboard"} class="block">
            <div class="flex items-center mb-3">
              <div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center group-hover:bg-blue-200 transition-colors duration-200">
                <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                </svg>
              </div>
            </div>
            <h4 class="font-semibold text-gray-800 mb-2 group-hover:text-blue-700 transition-colors duration-200">Tambah kursus baru</h4>
            <p class="text-gray-600 text-sm">Cipta kursus baru untuk peserta</p>
          </.link>
        </div>

        <!-- Box 2 - Pengesahan Permohonan (Admin only) -->
        <%= if @role == "admin" do %>
          <.link navigate={~p"/admin/permohonan"} class="block">
            <div class="bg-white border border-gray-200 border-l-4 border-l-green-300 rounded-xl p-6 hover:shadow-md transition-all duration-200 cursor-pointer group">
              <div class="flex items-center mb-3">
                <div class="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center group-hover:bg-green-200 transition-colors duration-200">
                  <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                  </svg>
                </div>
              </div>
              <h4 class="font-semibold text-gray-800 mb-2 group-hover:text-green-700 transition-colors duration-200">Pengesahan permohonan</h4>
              <p class="text-gray-600 text-sm">Semak dan sahkan permohonan baru</p>
            </div>
          </.link>
        <% end %>

        <!-- Box 3 - Senarai Peserta -->
        <.link navigate={if @role == "admin", do: ~p"/admin/peserta", else: ~p"/pekerja/peserta"} class="block">
          <div class="bg-white border border-gray-200 border-l-4 border-l-purple-300 rounded-xl p-6 hover:shadow-md transition-all duration-200 cursor-pointer group">
            <div class="flex items-center mb-3">
              <div class="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center group-hover:bg-purple-200 transition-colors duration-200">
                <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"></path>
                </svg>
              </div>
            </div>
            <h4 class="font-semibold text-gray-800 mb-2 group-hover:text-purple-700 transition-colors duration-200">Senarai peserta</h4>
            <p class="text-gray-600 text-sm">Senarai peserta yang mengikuti kursus</p>
          </div>
        </.link>
      </div>
    </div>
    """
  end

  defp statistics(assigns) do
    ~H"""
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-6 px-6 mb-8">
      <!-- Stat Box 1 - Jumlah Peserta -->
      <div class="bg-white border border-gray-200 border-l-4 border-l-blue-300 rounded-xl p-6 shadow-sm overflow-hidden relative">
        <div class="absolute top-0 right-0 w-16 h-16 bg-blue-50 rounded-full -translate-y-8 translate-x-8"></div>
        <div class="relative">
          <div class="flex items-center justify-between mb-2">
            <h4 class="text-sm font-medium text-blue-700">Jumlah Peserta</h4>
            <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
              <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"></path>
              </svg>
            </div>
          </div>
          <div class="text-3xl font-bold text-blue-900"><%= @jumlah_peserta || 0 %></div>
        </div>
      </div>

      <!-- Stat Box 2 - Kursus Tersedia -->
      <div class="bg-white border border-gray-200 border-l-4 border-l-green-300 rounded-xl p-6 shadow-sm overflow-hidden relative">
        <div class="absolute top-0 right-0 w-16 h-16 bg-green-50 rounded-full -translate-y-8 translate-x-8"></div>
        <div class="relative">
          <div class="flex items-center justify-between mb-2">
            <h4 class="text-sm font-medium text-green-700">Kursus Tersedia</h4>
            <div class="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center">
              <svg class="w-4 h-4 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
              </svg>
            </div>
          </div>
          <div class="text-3xl font-bold text-green-900"><%= @jumlah_kursus || 0 %></div>
        </div>
      </div>

      <!-- Stat Box 3 - Pendaftaran Baharu -->
      <div class="bg-white border border-gray-200 border-l-4 border-l-orange-300 rounded-xl p-6 shadow-sm overflow-hidden relative">
        <div class="absolute top-0 right-0 w-16 h-16 bg-orange-50 rounded-full -translate-y-8 translate-x-8"></div>
        <div class="relative">
          <div class="flex items-center justify-between mb-2">
            <h4 class="text-sm font-medium text-orange-700">Pendaftaran Baharu</h4>
            <div class="w-8 h-8 bg-orange-100 rounded-lg flex items-center justify-center">
              <svg class="w-4 h-4 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
              </svg>
            </div>
          </div>
          <div class="text-3xl font-bold text-orange-900"><%= @jumlah_pendaftaran_baru || 0 %></div>
        </div>
      </div>

      <!-- Stat Box 4 - Kadar Tamat -->
      <div class="bg-white border border-gray-200 border-l-4 border-l-purple-300 rounded-xl p-6 shadow-sm overflow-hidden relative">
        <div class="absolute top-0 right-0 w-16 h-16 bg-purple-50 rounded-full -translate-y-8 translate-x-8"></div>
        <div class="relative">
          <div class="flex items-center justify-between mb-2">
            <h4 class="text-sm font-medium text-purple-700">Kadar Tamat</h4>
            <div class="w-8 h-8 bg-purple-100 rounded-lg flex items-center justify-center">
              <svg class="w-4 h-4 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
              </svg>
            </div>
          </div>
          <div class="text-3xl font-bold text-purple-900"><%= @kadar_tamat || 0 %>%</div>
        </div>
      </div>
    </div>
    """
  end

  defp latest_registrations(assigns) do
    ~H"""
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 mx-6 mb-8 overflow-x-auto hover:shadow-lg transition-shadow duration-300">
      <div class="p-6 border-b border-gray-200 bg-gradient-to-r from-indigo-50 to-indigo-100">
        <h3 class="text-xl font-semibold text-indigo-800 flex items-center gap-2">
          <svg class="w-5 h-5 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path>
          </svg>
          Jumlah Pendaftaran Terkini
        </h3>
      </div>

      <table class="w-full min-w-max">
        <thead class="bg-gradient-to-r from-gray-50 to-gray-100">
          <tr>
            <th class="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Nama Kursus</th>
            <th class="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Jumlah Yang Memohon</th>
            <th class="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">Tarikh Tutup Permohonan</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <%= for {reg, index} <- Enum.with_index(@latest_registrations) do %>
            <tr class="hover:bg-indigo-50 transition-colors duration-200">
              <td class="px-6 py-4 text-sm font-medium text-gray-900">
                <div class="flex items-center gap-3">
                  <div class="w-8 h-8 bg-indigo-100 rounded-lg flex items-center justify-center">
                    <span class="text-xs font-semibold text-indigo-600"><%= rem(index, 9) + 1 %></span>
                  </div>
                  <%= reg.kursus %>
                </div>
              </td>
              <td class="px-6 py-4 text-sm">
                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                  <%= reg.jumlah_permohonan %>
                </span>
              </td>
              <td class="px-6 py-4 text-sm text-gray-600">
                <%= reg.tarikh_tutup |> Calendar.strftime("%d.%m.%Y") %>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end
end

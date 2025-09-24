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
        <svg class="w-6 h-6 text-gray-600" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" clip-rule="evenodd"
            d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0
            00-1.414-1.414L9 10.586 7.707 9.293a1 1 0
            00-1.414 1.414l2 2a1 1 0
            001.414 0l4-4z" />
        </svg>
        Tindakan pantas
      </h3>

      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Box 1 -->
        <div class="bg-white border rounded-lg p-6 hover:shadow-md cursor-pointer">
          <.link patch={if @role == "admin", do: ~p"/admin/kursus/new?return_to=/admin/dashboard", else: ~p"/pekerja/kursus/new?return_to=/pekerja/dashboard"} class="block">
            <h4 class="font-semibold text-gray-800 mb-2">Tambah kursus baru</h4>
            <p class="text-gray-600 text-sm">Cipta kursus baru untuk peserta</p>
          </.link>
        </div>

        <!-- Box 2 -->
        <%= if @role == "admin" do %>
          <.link navigate={~p"/admin/permohonan"} class="block">
            <div class="bg-white border rounded-lg p-6 hover:shadow-md cursor-pointer">
              <h4 class="font-semibold text-gray-800 mb-2">Pengesahan permohonan</h4>
              <p class="text-gray-600 text-sm">Semak dan sahkan permohonan baru</p>
            </div>
          </.link>
        <% end %>

        <!-- Box 3 -->
        <.link navigate={if @role == "admin", do: ~p"/admin/peserta", else: ~p"/pekerja/peserta"} class="block">
          <div class="bg-white border rounded-lg p-6 hover:shadow-md cursor-pointer">
            <h4 class="font-semibold text-gray-800 mb-2">Senarai peserta</h4>
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
      <!-- Stat Box 1 -->
      <div class="bg-white rounded-lg p-6 shadow-sm border overflow-hidden">
        <h4 class="text-sm text-gray-600">Jumlah peserta</h4>
        <div class="text-3xl font-bold text-gray-900"><%= @jumlah_peserta || 0 %></div>
      </div>

      <!-- Stat Box 2 -->
      <div class="bg-white rounded-lg p-6 shadow-sm border overflow-hidden">
        <h4 class="text-sm text-gray-600">Kursus Tersedia</h4>
        <div class="text-3xl font-bold text-gray-900"><%= @jumlah_kursus || 0 %></div>
      </div>

      <!-- Stat Box 3 -->
      <div class="bg-white rounded-lg p-6 shadow-sm border overflow-hidden">
        <h4 class="text-sm text-gray-600">Pendaftaran Baharu</h4>
        <div class="text-3xl font-bold text-gray-900"><%= @jumlah_pendaftaran_baru || 0 %></div>
      </div>

      <!-- Stat Box 4 -->
      <div class="bg-white rounded-lg p-6 shadow-sm border overflow-hidden">
        <h4 class="text-sm text-gray-600">Kadar Tamat</h4>
        <div class="text-3xl font-bold text-gray-900"><%= @kadar_tamat || 0 %>%</div>
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
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nama Kursus</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Jumlah Yang Memohon</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tarikh Tutup Permohonan</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <%= for reg <- @latest_registrations do %>
            <tr>
              <td class="px-6 py-4 text-sm"><%= reg.kursus %></td>
              <td class="px-6 py-4 text-sm"><%= reg.jumlah_permohonan%></td>
              <td class="px-6 py-4 text-sm"><%= reg.tarikh_tutup |> Calendar.strftime("%d.%m.%Y") %></td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end
end

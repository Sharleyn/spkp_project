defmodule SpkpProjectWeb.AdminDashboardLive do
  use SpkpProjectWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full min-h-screen bg-gray-100 flex">
      <!-- Sidebar -->
      <.live_component
        module={SpkpProjectWeb.SidebarComponent}
        id="sidebar"
        uri_path="/admin/dashboard" />

       <!-- Main Content -->
      <div class="flex-1 flex flex-col">
        <!-- Header -->
        <header class="bg-white shadow-sm border-b border-gray-200">
          <div class="flex justify-between items-center px-6 py-4">
            <div class="flex items-center space-x-4">
              <div class="flex items-center gap-4">
                <img src={~p"/images/a3.png"} alt="Logo" class="h-12">
              </div>
              <h1 class="text-xl font-semibold text-gray-800">SPKP Admin Dashboard</h1>
            </div>
            <div class="flex items-center space-x-4">
              <span class="text-gray-600">admin@gmail.com</span>
              <button class="text-gray-600 hover:text-gray-800">Logout</button>
              <div class="w-8 h-8 bg-gray-300 rounded-full"></div>
            </div>
          </div>
        </header>

        <!-- Quick Actions -->
        <div class="mb-8 p-6">
          <div class="flex items-center space-x-2 mb-4">
            <svg class="w-6 h-6 text-gray-600" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" clip-rule="evenodd"
                d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0
                00-1.414-1.414L9 10.586 7.707 9.293a1 1 0
                00-1.414 1.414l2 2a1 1 0
                001.414 0l4-4z"/>
            </svg>
            <h3 class="text-xl font-semibold text-gray-800">Tindakan pantas</h3>
          </div>

          <div class="grid md:grid-cols-3 gap-6">
            <div class="bg-white border rounded-lg p-6 hover:shadow-md cursor-pointer">
              <div class="flex items-center justify-between">
                <div>
                  <h4 class="font-semibold text-gray-800 mb-2">Tambah kursus baru</h4>
                  <p class="text-gray-600 text-sm">Cipta kursus baru untuk peserta</p>
                </div>
                <img src={~p"/images/users.png"} alt="Peserta" class="w-8 h-8" />
              </div>
            </div>

            <div class="bg-white border rounded-lg p-6 hover:shadow-md cursor-pointer">
              <div class="flex items-center justify-between">
                <div>
                  <h4 class="font-semibold text-gray-800 mb-2">Pengesahan permohonan</h4>
                  <p class="text-gray-600 text-sm">Semak dan sahkan permohonan baru</p>
                </div>
                <img src={~p"/images/sah.png"} alt="Pengesahan" class="w-8 h-8" />
              </div>
            </div>

            <div class="bg-white border rounded-lg p-6 hover:shadow-md cursor-pointer">
              <div class="flex items-center justify-between">
                <div>
                  <h4 class="font-semibold text-gray-800 mb-2">Senarai peserta</h4>
                  <p class="text-gray-600 text-sm">Senarai peserta yang mengikuti kursus</p>
                </div>
                <img src={~p"/images/usershijauu.png"} alt="SenaraiPeserta" class="w-8 h-8" />
              </div>
            </div>
          </div>
        </div>

        <!-- Statistik -->
        <div class="grid md:grid-cols-4 gap-6 px-6 mb-8">
          <div class="bg-white rounded-lg p-6 shadow-sm border">
            <div class="flex items-center justify-between w-full px-8">
              <img src={~p"/images/users.png"} alt="Peserta" class="w-10 h-10" />
              <div class="flex flex-col items-center">
                <h4 class="text-sm text-gray-600">Jumlah peserta</h4>
                <div class="text-3xl font-bold text-gray-900">2300</div>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-lg p-6 shadow-sm border">
            <div class="flex items-center justify-between w-full px-8">
              <img src={~p"/images/buku.png"} alt="Kursus" class="w-10 h-10" />
              <div class="flex flex-col items-center">
                <h4 class="text-sm text-gray-600">Kursus Tersedia</h4>
                <div class="text-3xl font-bold text-gray-900">20</div>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-lg p-6 shadow-sm border">
            <div class="flex items-center justify-between w-full px-8">
              <img src={~p"/images/tickuser.png"} alt="Pendaftaran" class="w-10 h-10" />
              <div class="flex flex-col items-center">
                <h4 class="text-sm text-gray-600">Pendaftaran Baharu</h4>
                <div class="text-3xl font-bold text-gray-900">132</div>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-lg p-6 shadow-sm border">
            <div class="flex items-center justify-between w-full px-8">
              <img src={~p"/images/sijil.png"} alt="KadarTamat" class="w-10 h-10" />
              <div class="flex flex-col items-center">
                <h4 class="text-sm text-gray-600">Kadar Tamat</h4>
                <div class="text-3xl font-bold text-gray-900">98%</div>
              </div>
            </div>
          </div>
        </div>

        <!-- Table -->
        <div class="bg-white rounded-lg shadow-sm border mx-6 mb-8">
          <div class="p-6 border-b border-gray-200">
            <h3 class="text-xl font-semibold text-gray-800">Jumlah Pendaftaran terkini</h3>
          </div>
          <div class="overflow-x-auto">
            <table class="w-full">
              <thead class="bg-gray-50">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Kursus</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Jumlah</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tarikh tamat</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr>
                  <td class="px-6 py-4 text-sm font-medium text-gray-900">Web Development Bootcamp</td>
                  <td class="px-6 py-4 text-sm text-gray-500">9</td>
                  <td class="px-6 py-4 text-sm text-gray-500">30.06.2025</td>
                </tr>
                <tr>
                  <td class="px-6 py-4 text-sm font-medium text-gray-900">Solekan</td>
                  <td class="px-6 py-4 text-sm text-gray-500">8</td>
                  <td class="px-6 py-4 text-sm text-gray-500">30.07.2025</td>
                </tr>
                <tr>
                  <td class="px-6 py-4 text-sm font-medium text-gray-900">Masakan</td>
                  <td class="px-6 py-4 text-sm text-gray-500">2</td>
                  <td class="px-6 py-4 text-sm text-gray-500">30.08.2025</td>
                </tr>
                <tr>
                  <td class="px-6 py-4 text-sm font-medium text-gray-900">Spa</td>
                  <td class="px-6 py-4 text-sm text-gray-500">1</td>
                  <td class="px-6 py-4 text-sm text-gray-500">30.09.2025</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    """
  end
end

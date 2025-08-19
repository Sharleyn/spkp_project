defmodule SpkpProjectWeb.PermohonanLive do
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
        uri_path="/admin/permohonan" />

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

        <!-- Main Content Area -->
        <div class="flex-1 p-6 bg-gray-50">
          <!-- Page Header -->
          <div class="mb-8">

            <h1 class="text-4xl font-bold text-gray-900 mb-2">Permohonan</h1>
            <p class="text-gray-600">Semak dan urus semua permohonan kursus</p>
          </div>

          <!-- Statistics Cards -->
          <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
            <!-- Jumlah Permohonan -->
            <div class="bg-white rounded-lg p-6 shadow-sm border">
              <div class="flex items-center justify-between">
                <div>
                  <p class="text-sm text-gray-600 mb-1">Jumlah permohonan</p>
                  <p class="text-3xl font-bold text-gray-900">50</p>
                </div>
                <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                  <svg class="w-6 h-6 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-6-3a2 2 0 11-4 0 2 2 0 014 0zm-2 4a5 5 0 00-4.546 2.916A5.986 5.986 0 0010 16a5.986 5.986 0 004.546-2.084A5 5 0 0010 11z" clip-rule="evenodd"/>
                  </svg>
                </div>
              </div>
            </div>

            <!-- Menunggu -->
            <div class="bg-white rounded-lg p-6 shadow-sm border">
              <div class="flex items-center justify-between">
                <div>
                  <p class="text-sm text-gray-600 mb-1">Menunggu</p>
                  <p class="text-3xl font-bold text-gray-900">50</p>
                </div>
                <div class="w-12 h-12 bg-yellow-100 rounded-lg flex items-center justify-center">
                  <svg class="w-6 h-6 text-yellow-600" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"/>
                  </svg>
                </div>
              </div>
            </div>

            <!-- Diterima -->
            <div class="bg-white rounded-lg p-6 shadow-sm border">
              <div class="flex items-center justify-between">
                <div>
                  <p class="text-sm text-gray-600 mb-1">Diterima</p>
                  <p class="text-3xl font-bold text-gray-900">50</p>
                </div>
                <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                  <svg class="w-6 h-6 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                  </svg>
                </div>
              </div>
            </div>

            <!-- Ditolak -->
            <div class="bg-white rounded-lg p-6 shadow-sm border">
              <div class="flex items-center justify-between">
                <div>
                  <p class="text-sm text-gray-600 mb-1">Ditolak</p>
                  <p class="text-3xl font-bold text-gray-900">50</p>
                </div>
                <div class="w-12 h-12 bg-red-100 rounded-lg flex items-center justify-center">
                  <svg class="w-6 h-6 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
                  </svg>
                </div>
              </div>
            </div>
          </div>

          <!-- Search and Filter Bar -->
          <div class="bg-white rounded-lg p-6 shadow-sm border mb-8">
            <div class="flex flex-col md:flex-row gap-4">
              <!-- Search Input -->
              <div class="flex-1 relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd"/>
                  </svg>
                </div>
                <input type="text" placeholder="Nama, email atau kursus ...." class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
              </div>

              <!-- Status Filter -->
              <div class="relative">
                <select class="block w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 appearance-none bg-white">
                  <option>Status permohonan</option>
                  <option>Semua</option>
                  <option>Menunggu</option>
                  <option>Diterima</option>
                  <option>Ditolak</option>
                </select>
                <div class="absolute inset-y-0 right-0 flex items-center pr-2 pointer-events-none">
                  <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd"/>
                  </svg>
                </div>
              </div>
            </div>
          </div>

          <!-- Applications Table -->
          <div class="bg-white rounded-lg shadow-sm border">
            <div class="overflow-x-auto">
              <table class="w-full">
                <thead class="bg-gray-50">
                  <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">NAMA PEMOHON</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">E-MEL</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">KURSUS DIPOHON</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">TARIKH PERMOHONAN</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">STATUS PERMOHONAN</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">TINDAKAN</th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                  <!-- Row 1 -->
                  <tr>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Ali bin Abu Bakar</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">aliabubakar@gmail.com</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Web Development</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">01.01.2025</td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">Diterima</span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <button class="bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700">Edit</button>
                    </td>
                  </tr>

                  <!-- Row 2 -->
                  <tr>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Aminan binti Ali</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">aminah@gmail.com</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Make Up</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">02.01.2025</td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800">Menunggu</span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <button class="bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700">Edit</button>
                    </td>
                  </tr>

                  <!-- Row 3 -->
                  <tr>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Siti binti Mukmin</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">sitimukmin@gmail.com</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Masakan</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">03.01.2025</td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">Diterima</span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <button class="bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700">Edit</button>
                    </td>
                  </tr>

                  <!-- Row 4 -->
                  <tr>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Abu bin Talib</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">abutalib@gmail.com</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Data Saintis</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">04.01.2025</td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">Diterima</span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <button class="bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700">Edit</button>
                    </td>
                  </tr>

                  <!-- Row 5 -->
                  <tr>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Syerina binti Osman</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">syerina@gmail.com</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Web Development</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">05.01.2025</td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800">Menunggu</span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <button class="bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700">Edit</button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Pagination -->
          <div class="flex justify-center items-center space-x-4 mt-8">
            <button class="bg-white border border-gray-300 text-gray-700 px-4 py-2 rounded-lg hover:bg-gray-50">
              Page 1
            </button>
            <button class="bg-blue-900 text-white px-4 py-2 rounded-lg hover:bg-blue-800">
              Seterusnya
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end
end

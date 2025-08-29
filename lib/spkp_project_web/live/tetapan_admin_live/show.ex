defmodule SpkpProjectWeb.EditProfileLive.Show do
  use SpkpProjectWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    {:noreply, assign(socket, :current_path, URI.parse(uri).path)}
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
        <!-- Header -->
        <header class="bg-white shadow-sm border-b border-gray-200">
          <div class="flex justify-between items-center px-6 py-4">
            <div class="flex items-center space-x-4">
              <div class="flex items-center gap-4">
                <img src={~p"/images/a3.png"} alt="Logo" class="h-12" />
              </div>

              <h1 class="text-xl font-semibold text-gray-800">Kursus Hub</h1>
            </div>

            <div class="flex items-center space-x-4">
              <span class="text-gray-600">admin@gmail.com</span>

                  <.link href={~p"/users/log_out"} method="delete" class="text-gray-600 hover:text-gray-800">
              Logout
              </.link>

              <div class="flex items-center space-x-2">
                <span class="text-gray-600">Admin</span>
                <div class="w-8 h-8 bg-black rounded-full"></div>
              </div>
            </div>
          </div>
        </header>
        <!-- Main Content Area -->
        <div class="flex-1 bg-gray-100 p-6">
          <!-- Breadcrumb and Title -->
          <div class="mb-6">
            <div class="flex items-center space-x-2 mb-2">
              <svg class="w-6 h-6 text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                <path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z" />
              </svg>
              <h2 class="text-3xl font-semibold text-gray-800">Dashboard Admin Kursus</h2>
            </div>

            <div class="text-sm text-gray-500">Tetapan admin</div>
          </div>
          <!-- Edit Profile Section -->
          <div class="bg-white rounded-lg shadow-sm border p-8 max-w-2xl mx-auto">
            <h3 class="text-3xl font-semibold text-gray-800 text-center mb-8">Edit Profile</h3>
            <!-- Profile Picture -->
            <div class="flex flex-col items-center mb-8">
              <div class="w-32 h-32 bg-black rounded-full mb-4 flex items-center justify-center">
                <!-- Profile picture placeholder -->
              </div>
               <button class="text-xl font-semibold text-gray-800 hover:text-gray-600">Edit</button>
            </div>
            <!-- Form Fields -->
            <form class="space-y-6">
              <div>
                <label class="block text-xl font-semibold text-gray-800 mb-2">Nama Penuh</label>
                <input
                  type="text"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="Masukkan nama penuh"
                />
              </div>

              <div>
                <label class="block text-xl font-semibold text-gray-800 mb-2">Emel</label>
                <input
                  type="email"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="Masukkan emel"
                />
              </div>

              <div>
                <label class="block text-xl font-semibold text-gray-800 mb-2">No telefon</label>
                <input
                  type="tel"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="Masukkan nombor telefon"
                />
              </div>
              <!-- Save Button -->
              <div class="flex justify-center pt-4">
                <button
                  type="submit"
                  class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-8 rounded-lg transition duration-200"
                >
                  Simpan
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    """
  end
end

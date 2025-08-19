defmodule SpkpProjectWeb.UserDashboardLive do
  use SpkpProjectWeb, :live_view

  alias SpkpProjectWeb.UserDashboardLive

  @impl true
  # 'mount' digunakan untuk menetapkan data awal (initial state)
  def mount(_params, _session, socket) do
    # Data contoh (mock data) untuk dashboard
    current_user = socket.assigns.current_user
    assigns = %{
      current_user_name: current_user.full_name,
      sidebar_open: false,
      user_menu_open: false,
      active_applications_count: 3,
      available_courses_count: 3,
      completed_courses_count: 0,
      recent_applications: [
        %{name: "Kursus Komputer Asas", date: "2025-01-24", status: "Diterima", status_class: "bg-green-100 text-green-600"},
        %{name: "Kursus Bahasa Inggeris", date: "2025-02-17", status: "Dalam Proses", status_class: "bg-yellow-100 text-yellow-600"},
        %{name: "Kursus Kemahiran Digital", date: "2025-02-21", status: "Ditolak", status_class: "bg-red-100 text-red-600"},
      ],
      available_courses: [
        %{name: "Kursus Komputer Asas", duration: "4 minggu", slots: "15 tempat"},
        %{name: "Kursus Bahasa Inggeris", duration: "2 minggu", slots: "8 tempat"},
        %{name: "Kursus Kemahiran Digital", duration: "3 minggu", slots: "20 tempat"},
      ]
    }
    socket = assign(socket, assigns)

    # Menetapkan handler untuk toggle sidebar di mobile
    socket = assign(socket, sidebar_open: false)

    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:sidebar_open, false)
      |> assign(:user_menu_open, false)   # 👈 ini wajib

    {:ok, socket}
  end

  @impl true
  def handle_event("logout", _params, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Anda telah log keluar.")
     |> redirect(to: ~p"/lamanutama")}
  end

  # 'handle_event' digunakan untuk menguruskan interaksi pengguna
  # ========== EVENTS ==========

    def handle_event("toggle_sidebar", _params, socket) do
      {:noreply, update(socket, :sidebar_open, &(!&1))}
    end

    def handle_event("toggle_user_menu", _params, socket) do
        {:noreply, update(socket, :user_menu_open, &(!&1))}
    end


    def handle_event("close_user_menu", _params, socket) do
      {:noreply, assign(socket, :user_menu_open, false)}
    end

  # 'render' berfungsi sebagai template HTML LiveView
  # ========== RENDER ==========
    @impl true
    def render(assigns) do
      ~H"""
      <div class="bg-white-100 min-h-screen antialiased text-gray-800">

        <!-- Sidebar -->
        <aside
          class={
            "fixed inset-y-0 left-0 z-40 w-64 p-6 flex flex-col items-start shadow-lg transition-transform duration-300 ease-in-out " <>
            (if @sidebar_open, do: "translate-x-0", else: "-translate-x-full md:translate-x-0") <>
            " bg-[#191970] text-white"
          }
        >
          <!-- Brand -->
          <div class="mb-10 w-full">
            <div class="text-2xl text-center font-extrabold tracking-wide">SPKP</div>
            <div class="text-xs text-center font-bold text-indigo-200">Sistem Permohonan Kursus & Pengurusan</div>
          </div>
                <nav class="w-full flex-grow">
                    <ul class="space-y-4">
                        <li>
                             <a href="#" class="flex items-center space-x-3 font-semibold p-3 rounded-xl hover:bg-indigo-700 transition-colors duration-200">
                             <img src={~p"/images/right.png"} alt="Laman Utama" class="w-5 h-5" />
                             <span>Laman Utama</span>
                             </a>
                        </li>
                        <li>
                            <a href="#" class="flex items-center space-x-3 font-semibold p-3 rounded-xl hover:bg-indigo-700 transition-colors duration-200">
                                <img src={~p"/images/right.png"} alt="Profil Pengguna" class="w-5 h-5" />
                                <span>Profil Pengguna</span>
                            </a>
                        </li>
                        <li>
                            <a href="#" class="flex items-center space-x-3 font-semibold p-3 rounded-xl hover:bg-indigo-700 transition-colors duration-200">
                                <img src={~p"/images/right.png"} alt="Senarai Kursus" class="w-5 h-5" />
                                <span>Senarai Kursus</span>
                            </a>
                        </li>
                        <li>
                            <a href="#" class="flex items-center space-x-3 font-semibold p-3 rounded-xl hover:bg-indigo-700 transition-colors duration-200">
                                <img src={~p"/images/right.png"} alt="Permohonan Saya" class="w-5 h-5" />
                                <span>Permohonan Saya</span>
                            </a>
                        </li>
                    </ul>
                </nav>
                <button class="md:hidden p-2 rounded-lg text-white absolute top-4 right-4 focus:outline-none" phx-click="toggle_sidebar">
                    <i data-lucide="x" class="w-6 h-6"></i>
                </button>
            </aside>

            <!-- Main content area -->
            <div class="flex-grow md:ml-64 p-6 transition-all duration-300 ease-in-out">
                <button class="md:hidden p-2 rounded-lg text-gray-800 focus:outline-none fixed top-4 left-4 z-40 bg-white shadow-md" phx-click="toggle_sidebar">
                    <i data-lucide="menu" class="w-6 h-6"></i>
                </button>

                <!-- Top Header Bar -->
                <header class="flex justify-end items-center mb-6">
                        <div class="relative"

                <!-- Button User -->
                     <button
                            phx-click="toggle_user_menu"
                                class="flex items-center space-x-2 p-2 hover:bg-indigo-100 rounded-lg gap-6 transition-colors duration-200 focus:outline-none">
                                      <img src={~p"/images/tableuser.png"} alt="User" class="w-8 h-8 rounded-full border border-gray-300" />
                                      <span class="font-medium"><%= @current_user_name %></span>
                                      <img src={~p"/images/kotak - dropdown.png"} alt="Dropdown" />
                     </button>

                     <!-- Dropdown Menu -->
                     <%= if @user_menu_open do %>
                        <div class="absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-lg border border-gray-200 z-10">
                              <!-- Setting -->
                              <.link navigate={~p"/users/settings"}
                                 class="block px-4 py-2 text-sm text-black-700 hover:bg-gray-100 rounded-t-xl">
                                     Tetapan
                              </.link>

                              <!-- Logout -->
                              <.link href={~p"/halamanutama"} method="delete"
                                class="block w-full text-left px-4 py-2 text-sm text-black-700 hover:bg-gray-100 rounded-b-xl">
                                     Log Keluar
                              </.link>
                        </div>
                      <% end %>
                    </div>
                </header>

                <!-- Dashboard Content -->
                <main>
                    <h2 class="text-2xl font-semibold mb-1">Selamat Datang, <%= @current_user_name %></h2>
                    <p class="text-gray-500 mb-6">Urus Permohonan Kursus Dan Lihat Perkembangan Anda Di Sini</p>

                    <!-- Summary Cards Section -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                        <div class="bg-white p-6 rounded-3xl shadow-lg flex items-center justify-between">
                            <div>
                                <p class="text-gray-500 text-sm">Permohonan Aktif</p>
                                <h3 class="text-3xl font-bold mt-1"><%= @active_applications_count %></h3>
                            </div>
                            <div class="p-3 bg-indigo-100 rounded-full text-indigo-600">
                                <i data-lucide="file-text" class="w-8 h-8"></i>
                            </div>
                        </div>
                        <div class="bg-white p-6 rounded-3xl shadow-lg flex items-center justify-between">
                            <div>
                                <p class="text-gray-500 text-sm">Kursus Tersedia</p>
                                <h3 class="text-3xl font-bold mt-1"><%= @available_courses_count %></h3>
                            </div>
                            <div class="p-3 bg-green-100 rounded-full text-green-600">
                                <i data-lucide="book" class="w-8 h-8"></i>
                            </div>
                        </div>
                        <div class="bg-white p-6 rounded-3xl shadow-lg flex items-center justify-between">
                            <div>
                                <p class="text-gray-500 text-sm">Kursus Selesai</p>
                                <h3 class="text-3xl font-bold mt-1"><%= @completed_courses_count %></h3>
                            </div>
                            <div class="p-3 bg-yellow-100 rounded-full text-yellow-600">
                                <i data-lucide="award" class="w-8 h-8"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Status Profil and Permohonan Terkini Section -->
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                        <div class="bg-white p-6 rounded-3xl shadow-lg">
                            <h4 class="flex items-center text-lg font-semibold mb-4 text-gray-700">
                                <i data-lucide="circle-user" class="mr-2"></i>
                                Status Profil
                            </h4>
                            <p class="text-gray-500 mb-4">Lengkapkan Profil Untuk Permohonan Yang Lebih Baik</p>
                            <a href="#" class="inline-block bg-blue-600 text-white px-6 py-2 rounded-full font-medium hover:bg-blue-700 transition-colors duration-200">
                                <i data-lucide="pencil" class="inline-block mr-2 w-4 h-4"></i>
                                Kemaskini Profil
                            </a>
                        </div>
                        <div class="bg-white p-6 rounded-3xl shadow-lg">
                            <h4 class="flex items-center text-lg font-semibold mb-4 text-gray-700">
                                <i data-lucide="file-text" class="mr-2"></i>
                                Permohonan Terkini
                            </h4>
                            <p class="text-gray-500 mb-4">Status Permohonan Kursus Anda</p>
                            <div class="space-y-4">
                                <%= for app <- @recent_applications do %>
                                    <div class="flex items-center justify-between p-4 bg-gray-50 rounded-2xl">
                                        <div>
                                            <p class="font-medium"><%= app.name %></p>
                                            <p class="text-xs text-gray-400">Tarikh Mohon: <%= app.date %></p>
                                        </div>
                                        <span class={"text-xs font-semibold px-2 py-1 rounded-full #{app.status_class}"}><%= app.status %></span>
                                    </div>
                                <% end %>
                            </div>
                            <div class="mt-6 text-center">
                                <a href="#" class="inline-block text-blue-600 font-medium hover:text-blue-800 transition-colors duration-200">Lihat Semua Permohonan</a>
                            </div>
                        </div>
                    </div>

                    <!-- Kursus Tersedia Section -->
                    <div class="bg-white p-6 rounded-3xl shadow-lg">
                        <h4 class="flex items-center text-lg font-semibold mb-4 text-gray-700">
                            <i data-lucide="book" class="mr-2"></i>
                            Kursus Tersedia
                        </h4>
                        <p class="text-gray-500 mb-4">Kursus Yang Boleh Anda Mohon</p>
                        <div class="space-y-4">
                            <%= for course <- @available_courses do %>
                                <div class="flex items-center justify-between p-4 bg-gray-50 rounded-2xl">
                                    <div>
                                        <p class="font-medium"><%= course.name %></p>
                                        <p class="text-xs text-gray-400"><%= course.duration %> &bull; <%= course.slots %></p>
                                    </div>
                                    <a href="#" class="bg-blue-600 text-white text-sm font-semibold px-4 py-2 rounded-full hover:bg-blue-700 transition-colors duration-200">MOHON</a>
                                </div>
                            <% end %>
                        </div>
                        <div class="mt-6 text-center">
                            <a href="#" class="inline-block text-blue-600 font-medium hover:text-blue-800 transition-colors duration-200">Lihat Semua Kursus</a>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <script>
            lucide.createIcons();
        </script>
    """
  end
end

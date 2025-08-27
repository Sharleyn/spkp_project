defmodule SpkpProjectWeb.UserDashboardLive do
  use SpkpProjectWeb, :live_view


  @impl true
def mount(_params, _session, socket) do
  current_user = socket.assigns.current_user

  available_courses =
    SpkpProject.Kursus.list_all_courses()
    |> Enum.take(3)  # ambil maksimum 3 kursus untuk dashboard

  socket =
    socket
    |> assign(:current_user_name, current_user.full_name)
    |> assign(:sidebar_open, true)
    |> assign(:user_menu_open, false)
    |> assign(:available_courses, available_courses)
    |> assign(:active_applications_count, 3)
    |> assign(:available_courses_count, length(available_courses))
    |> assign(:completed_courses_count, 0)
    |> assign(:recent_applications, [
      %{name: "Kursus Komputer Asas", date: "2025-01-24", status: "Diterima", status_class: "bg-green-100 text-green-600"},
      %{name: "Kursus Bahasa Inggeris", date: "2025-02-17", status: "Dalam Proses", status_class: "bg-yellow-100 text-yellow-600"},
      %{name: "Kursus Kemahiran Digital", date: "2025-02-21", status: "Ditolak", status_class: "bg-red-100 text-red-600"}
    ])

  {:ok, socket}
end

   # Hook untuk inject current_path dan sidebar_open
    def on_mount(:default, _params, _session, socket) do
    {:cont,
       socket
       |> assign(:current_path, socket.host_uri.path)
       |> assign_new(:sidebar_open, fn -> true end)  # default sidebar terbuka
  }
end

  # 'render' berfungsi sebagai template HTML LiveView
  # ========== RENDER ==========
    @impl true
    def render(assigns) do
      ~H"""
      <div class="bg-white-100 min-h-screen antialiased text-gray-800">

      <!-- Burger Button -->
            <button class="p-2 rounded-lg text-white absolute top-4 left-4 focus:outline-none z-50"
               phx-click="toggle_sidebar">
                   <i class="fa fa-bars fa-lg text-indigo-300" aria-hidden="true"></i>
           </button>

         <!-- Sidebar -->
              <aside
                   class={"fixed inset-y-0 left-0 z-40 w-64 p-6 flex flex-col items-start shadow-lg transition-transform duration-300 ease-in-out " <>
                           (if @sidebar_open, do: "translate-x-0", else: "-translate-x-full") <>
                            " bg-[#191970] text-white" }>

          <!-- Brand -->
               <div class="mt-4 mb-10 w-full">
               <div class="text-2xl text-center font-extrabold tracking-wide">SPKP</div>
               <div class="text-xs text-center font-bold text-indigo-200">
                    Sistem Permohonan Kursus & Pengurusan
               </div>
            </div>

          <!-- Menu -->
              <nav class="w-full flex-grow">
                <ul class="space-y-4">
                  <li>
                      <.link navigate={~p"/userdashboard"}
                           class="flex items-center space-x-3 font-semibold p-3 rounded-xl hover:bg-indigo-700 transition-colors duration-200">
                           <img src={~p"/images/right.png"} alt="Laman Utama" class="w-5 h-5" />
                            <span>Laman Utama</span>
                      </.link>
                  </li>
                <li>
                      <.link navigate={~p"/userprofile"}
                            class="flex items-center space-x-3 font-semibold p-3 rounded-xl hover:bg-indigo-700 transition-colors duration-200">
                        <img src={~p"/images/right.png"} alt="Profil Pengguna" class="w-5 h-5" />
                            <span>Profil Saya</span>
                      </.link>
                   </li>
                <li>
                      <.link navigate={~p"/senaraikursususer"}
                           class="flex items-center space-x-3 font-semibold p-3 rounded-xl hover:bg-indigo-700 transition-colors duration-200">
                       <img src={~p"/images/right.png"} alt="Senarai Kursus" class="w-5 h-5" />
                           <span>Senarai Kursus</span>
                      </.link>
                    </li>
                <li>
                      <.link navigate={~p"/permohonanuser"}
                          class="flex items-center space-x-3 font-semibold p-3 rounded-xl hover:bg-indigo-700 transition-colors duration-200">
                       <img src={~p"/images/right.png"} alt="Permohonan Saya" class="w-5 h-5" />
                           <span>Permohonan Saya</span>
                    </.link>
                 </li>
              </ul>
            </nav>
          </aside>

            <!-- Main content area -->
            <div class={"flex-grow p-6 transition-all duration-300 ease-in-out " <>
                         (if @sidebar_open, do: "md:ml-64", else: "md:ml-0 mx-auto")}>

                <!-- Top Header Bar -->
                <header class="flex justify-end items-center mb-6">
                        <div class="relative">

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
                        <div class="bg-orange-100 p-6 rounded-3xl shadow-lg flex items-center justify-between">
                            <div>
                                <p class="text-orange-700 text-sm font-medium">Permohonan Aktif</p>
                                <h3 class="text-3xl font-bold mt-1"><%= @active_applications_count %></h3>
                            </div>
                                <img src={~p"/images/paper.png"} alt="Paper Icon" class="w-8 h-8" />
                        </div>
                        <div class="bg-green-100 p-6 rounded-3xl shadow-lg flex items-center justify-between">
                            <div>
                                <p class="text-green-700 text-sm font-medium">Kursus Tersedia</p>
                                <h3 class="text-3xl font-bold mt-1"><%= @available_courses_count %></h3>
                            </div>
                                <img src={~p"/images/book.png"} alt="Book Icon" class="w-10 h-10" />
                        </div>
                        <div class="bg-blue-100 p-6 rounded-3xl shadow-lg flex items-center justify-between">
                            <div>
                                <p class="text-blue-700 text-sm font-medium">Kursus Selesai</p>
                                <h3 class="text-3xl font-bold mt-1"><%= @completed_courses_count %></h3>
                            </div>
                                <img src={~p"/images/certificate.png"} alt="Certificate Icon" class="w-10 h-10" />
                        </div>
                    </div>

            <!-- Status Profil and Permohonan Terkini Section -->
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                        <div class="bg-sky-50 p-6 rounded-3xl shadow-lg">
                            <h4 class="flex justify-center px-8 mt-6 items-center text-lg font-semibold mb-4 text-black-700">
                                <img src={~p"/images/tableuser.png"} alt="Certificate Icon" class="w-10 h-10 mr-2" />
                                Status Profil
                            </h4>
                            <p class="text-gray-600 text-center font-medium px-10 mb-4">Lengkapkan Profil Untuk Permohonan Yang Lebih Baik</p>
                            <div class="flex mt-10 justify-center">

                            <.link navigate={~p"/userprofile"} class="inline-flex items-center bg-blue-700 bg-opacity-80 text-white px-12 py-2 rounded-full font-medium hover:bg-[#43C6DB] transition-colors duration-200">
                                <img src={~p"/images/userprofile.png"} alt="userprofile Icon" class="w-4 h-4 mr-2" />
                                Kemaskini Profil
                            </.link>
                            </div>
                        </div>

                        <div class="bg-[#C8C4DF] bg-opacity-20 p-6 rounded-3xl shadow-lg">
                            <h4 class="flex items-center text-lg font-bold gap-4 mb-4 text-gray-700">
                                <img src={~p"/images/bookclock.png"} alt="Bookclock Icon" class="w-8 h-8" />
                                Permohonan Terkini
                            </h4>
                            <p class="text-gray-700 font-medium mb-4"> Status Permohonan Kursus Anda </p>
                            <div class="space-y-4">
                                <%= for app <- @recent_applications do %>
                                    <div class="flex items-center justify-between p-4 bg-[#C8C4DF] bg-opacity-50 rounded-2xl">
                                        <div>
                                            <p class="font-medium"><%= app.name %></p>
                                            <p class="text-xs text-gray-500">Tarikh Mohon: <%= app.date %></p>
                                        </div>
                                        <span class={"text-xs font-semibold px-2 py-1 rounded-full #{app.status_class}"}><%= app.status %></span>
                                    </div>
                                <% end %>
                            </div>
                            <div class="mt-6 text-center">
                                 <.link navigate={~p"/permohonanuser"}
                                      class="inline-block border border-violet-500 text-black-600 px-6 py-2 rounded-lg font-medium hover:bg-[#C8C4DF] bg-opacity-80 hover:text-black transition-colors duration-200">
                                         Lihat Semua Permohonan
                                 </.link>
                             </div>
                        </div>
                    </div>

                    <!-- Kursus Terkini Full Width -->
                        <div class="mb-8">
                           <div class="bg-rose-50 p-6 rounded-3xl shadow-lg">
                              <h4 class="flex items-center text-lg font-bold gap-4 mb-4 text-gray-700">
                                  <img src={~p"/images/book.png"} alt="Book Icon" class="w-8 h-8" />
                                    Kursus Terkini
                            </h4>

                       <div class="space-y-4">
                         <%= for course <- @available_courses do %>
                       <div class="flex items-center justify-between p-4 bg-zinc-50 rounded-2xl shadow hover:shadow-md transition-shadow duration-200">
                       <div>
                         <p class="font-medium text-gray-800"><%= course.nama_kursus %></p>
                         <p class="text-xs text-gray-500">
                            <%= course.tarikh_mula %> - <%= course.tarikh_akhir %> &bull; Kuota: <%= course.kuota %>
                         </p>
                       </div>
                            <.link navigate={~p"/senaraikursususer"} class="bg-blue-600 text-white text-sm font-semibold px-4 py-2 rounded-full hover:bg-blue-700 transition-colors duration-200">
                              Lihat
                      </.link>
                    </div>
                  <% end %>
                </div>

                 <div class="mt-6 text-center">
                    <.link navigate={~p"/senaraikursususer"} class="inline-block border border-violet-500 text-black-600 px-6 py-2 rounded-lg font-medium hover:bg-[#C8C4DF] bg-opacity-80 hover:text-black transition-colors duration-200">
                       Lihat Semua Kursus
                    </.link>
                 </div>
               </div>
             </div>

                </main>
            </div>
        </div>
    """
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
    {:noreply, assign(socket, :sidebar_open, !socket.assigns.sidebar_open)}
  end

  def handle_event("toggle_user_menu", _params, socket) do
    {:noreply, assign(socket, :user_menu_open, !socket.assigns.user_menu_open)}
  end

  def handle_event("close_user_menu", _params, socket) do
    {:noreply, assign(socket, :user_menu_open, false)}
  end

end

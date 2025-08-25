defmodule SpkpProjectWeb.SenaraiKursusLive do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Kursus.Kursuss   # 👈 schema kursus
  alias SpkpProject.Repo             # 👈 akses DB


  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:sidebar_open, true)
      |> assign(:user_menu_open, false)
      |> assign(:current_user_name, "Ali Bin Abu") # 👈 dummy name user

      # ambil semua kursus dari DB
      Kursus = Repo.all(Kursuss)

    {:ok, assign(socket, :Kursus, Kursus)}
  end


    def handle_event("logout", _params, socket) do
      {:noreply,
       socket
       |> put_flash(:info, "Anda telah log keluar.")
       |> redirect(to: ~p"/lamanutama")}
    end

    # 'handle_event' digunakan untuk menguruskan interaksi pengguna
    # ========== EVENTS ==========

      def handle_event("toggle_sidebar", _params, socket) do
        {:noreply, update(socket, :sidebar_open, fn open -> not open end)}
      end

      def handle_event("toggle_user_menu", _params, socket) do
        {:noreply, update(socket, :user_menu_open, &(!&1))}
      end

      def handle_event("close_user_menu", _params, socket) do
        {:noreply, assign(socket, :user_menu_open, false)}
      end

  def render(assigns) do
    ~H"""

    <div class="bg-white-100 min-h-screen antialiased text-gray-800">

      <!-- Burger Button -->
            <button class="p-2 rounded-lg text-white absolute top-4 left-4 focus:outline-none z-50"
               phx-click="toggle_sidebar">
                   <img src={~p"/images/burger3.png"} alt="Burger Icon" class="w-6 h-6" />
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

    <div class="max-w-4xl mx-auto mt-10 bg-white shadow-md rounded-2xl p-6">
      <h2 class="text-2xl font-bold text-gray-700 mb-4">📚 Senarai Kursus Saya</h2>

      <table class="w-full text-left border-collapse">
        <thead>
          <tr class="bg-gray-100 text-gray-700">
            <th class="p-3">#</th>
            <th class="p-3">Nama Kursus</th>
            <th class="p-3">Status</th>
          </tr>
        </thead>
        <tbody>
          <%= for course <- @courses do %>
            <tr class="border-b hover:bg-gray-50">
              <td class="p-3"><%= course.id %></td>
              <td class="p-3"><%= course.title %></td>
              <td class="p-3">
                <span class={
                  case course.status do
                    "Disahkan" -> "text-green-600 font-semibold"
                    "Dalam Proses" -> "text-yellow-600 font-semibold"
                    "Ditolak" -> "text-red-600 font-semibold"
                    _ -> "text-gray-600"
                  end
                }>
                  <%= course.status %>
                </span>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>

      <div class="pt-6">
        <.link navigate={~p"/userdashboard"} class="inline-block px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
          ← Kembali ke Dashboard
        </.link>
       </div>
      </div>
     </div>
    </div>
    """
  end
end

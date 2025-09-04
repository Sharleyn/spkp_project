defmodule SpkpProjectWeb.PermohonanUserLive do
  use SpkpProjectWeb, :live_view


  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    socket =
     socket
     |> assign(:current_user_name, current_user.full_name)
     |> assign(:sidebar_open, true)
     |> assign(:user_menu_open, false)

   {:ok, socket}
 end

 def on_mount(:default, _params, _session, socket) do
  {:cont,
     socket
     |> assign(:current_path, socket.host_uri.path)
     |> assign_new(:sidebar_open, fn -> true end)  # default sidebar terbuka
}
end



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
      <aside class={"fixed inset-y-0 left-0 z-40 w-64 p-6 flex flex-col items-start shadow-lg transition-transform duration-300 ease-in-out " <>
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
                    <.link navigate={~p"/userdashboard"} class={nav_class(@live_action, :dashboard)}
                   aria-current={if @live_action == :dashboard, do: "page", else: nil}>
              <img src={~p"/images/right.png"} alt="Laman Utama" class="w-5 h-5" />
              <span>Laman Utama</span>
            </.link>
          </li>

          <li>
            <.link navigate={~p"/userprofile"} class={nav_class(@live_action, :profile)}
                   aria-current={if @live_action == :profile, do: "page", else: nil}>
              <img src={~p"/images/right.png"} alt="Profil Saya" class="w-5 h-5" />
              <span>Profil Saya</span>
            </.link>
          </li>

          <li>
            <.link navigate={~p"/senaraikursususer"} class={nav_class(@live_action, :courses)}
                   aria-current={if @live_action == :courses, do: "page", else: nil}>
              <img src={~p"/images/right.png"} alt="Senarai Kursus" class="w-5 h-5" />
              <span>Senarai Kursus</span>
            </.link>
          </li>

          <li>
            <.link navigate={~p"/permohonanuser"} class={nav_class(@live_action, :applications)}
                   aria-current={if @live_action == :applications, do: "page", else: nil}>
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

  defp nav_class(current, expected) do
    base = "flex items-center space-x-3 font-semibold p-3 rounded-xl transition-colors duration-200"

    if current == expected do
      base <> " bg-indigo-700 text-white"  # aktif
    else
      base <> " hover:bg-indigo-700 text-gray-300" # tidak aktif
    end
  end

end

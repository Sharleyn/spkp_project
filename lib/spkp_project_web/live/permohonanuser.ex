defmodule SpkpProjectWeb.PermohonanUserLive do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Userpermohonan

  # ========== MOUNT ==========
  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    applications = Userpermohonan.list_user_applications(current_user.id)

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:current_user_name, current_user.full_name)
     |> assign(:sidebar_open, true)
     |> assign(:user_menu_open, false)
     |> assign(:applications, applications)
     |> assign(:filter, "Semua Keputusan")}
  end

  # ========== EVENTS ==========

  # Logout
  @impl true
  def handle_event("logout", _params, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Anda telah log keluar.")
     |> redirect(to: ~p"/lamanutama")}
  end

  # Toggle Sidebar
  def handle_event("toggle_sidebar", _params, socket) do
    {:noreply, assign(socket, :sidebar_open, !socket.assigns.sidebar_open)}
  end

  # Toggle User Menu
  def handle_event("toggle_user_menu", _params, socket) do
    {:noreply, assign(socket, :user_menu_open, !socket.assigns.user_menu_open)}
  end

  def handle_event("close_user_menu", _params, socket) do
    {:noreply, assign(socket, :user_menu_open, false)}
  end

  # Filter permohonan
  def handle_event("filter", %{"filter" => filter_by}, socket) do
    apps = Userpermohonan.list_user_applications(socket.assigns.current_user.id, filter_by)
    {:noreply, assign(socket, applications: apps, filter: filter_by)}
  end

  # Cari kursus
  def handle_event("search", %{"value" => term}, socket) do
    apps = Userpermohonan.search_user_applications(socket.assigns.current_user.id, term)
    {:noreply, assign(socket, applications: apps)}
  end

  # Delete permohonan
  def handle_event("delete", %{"id" => id}, socket) do
    case Userpermohonan.delete_application(id) do
      {:ok, _} ->
        apps = Userpermohonan.list_user_applications(socket.assigns.current_user.id, socket.assigns.filter)
        {:noreply, assign(socket, applications: apps)}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Gagal memadam permohonan.")}
    end
  end

  # ========== HELPERS ==========
  defp nav_class(current, expected) do
    base = "flex items-center space-x-3 font-semibold p-3 rounded-xl transition-colors duration-200"
    if current == expected do
      base <> " bg-indigo-700 text-white"  # aktif
    else
      base <> " hover:bg-indigo-700 text-gray-300" # tidak aktif
    end
  end

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
              <.link navigate={~p"/userdashboard"} class={nav_class(@live_action, :dashboard)}>
                <img src={~p"/images/right.png"} alt="Laman Utama" class="w-5 h-5" />
                <span>Laman Utama</span>
              </.link>
            </li>
            <li>
              <.link navigate={~p"/userprofile"} class={nav_class(@live_action, :profile)}>
                <img src={~p"/images/right.png"} alt="Profil Saya" class="w-5 h-5" />
                <span>Profil Saya</span>
              </.link>
            </li>
            <li>
              <.link navigate={~p"/senaraikursususer"} class={nav_class(@live_action, :courses)}>
                <img src={~p"/images/right.png"} alt="Senarai Kursus" class="w-5 h-5" />
                <span>Senarai Kursus</span>
              </.link>
            </li>
            <li>
              <.link navigate={~p"/permohonanuser"} class={nav_class(@live_action, :applications)}>
                <img src={~p"/images/right.png"} alt="Permohonan Saya" class="w-5 h-5" />
                <span>Permohonan Saya</span>
              </.link>
            </li>
          </ul>
        </nav>
      </aside>

      <!-- Main content -->
      <div class={"flex-grow p-6 transition-all duration-300 ease-in-out " <>
                         (if @sidebar_open, do: "md:ml-64", else: "md:ml-0 mx-auto")}>
        <!-- Top Header Bar -->
        <header class="flex justify-end items-center mb-6">
          <div class="relative">
            <button phx-click="toggle_user_menu"
                    class="flex items-center space-x-2 p-2 hover:bg-indigo-100 rounded-lg gap-6 transition-colors duration-200 focus:outline-none">
              <img src={~p"/images/tableuser.png"} alt="User" class="w-8 h-8 rounded-full border border-gray-300" />
              <span class="font-medium"><%= @current_user_name %></span>
              <img src={~p"/images/kotak - dropdown.png"} alt="Dropdown" />
            </button>

            <!-- Dropdown -->
            <%= if @user_menu_open do %>
              <div class="absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-lg border border-gray-200 z-10">
                <.link navigate={~p"/users/settings"}
                       class="block px-4 py-2 text-sm text-black-700 hover:bg-gray-100 rounded-t-xl">
                  Tetapan
                </.link>
                <.link href={~p"/halamanutama"} method="delete"
                       class="block w-full text-left px-4 py-2 text-sm text-black-700 hover:bg-gray-100 rounded-b-xl">
                  Log Keluar
                </.link>
              </div>
            <% end %>
          </div>
        </header>

        <!-- ========== PERMOHONAN LIST ========== -->
        <div class="p-6 bg-gray-100 min-h-screen">
          <div class="flex justify-between items-center mb-6">
            <h1 class="text-xl font-semibold">Permohonan Saya</h1>
          </div>

          <!-- Statistik -->
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
            <div class="bg-white p-4 rounded-lg shadow flex items-center justify-between">
              <div>
                <p class="text-gray-500">Jumlah Permohonan</p>
                <p class="text-2xl font-bold"><%= length(@applications) %></p>
              </div>
            </div>
          </div>

          <!-- Search + Filter -->
          <div class="flex flex-col sm:flex-row items-center gap-4 mb-6">
            <div class="relative w-full sm:w-1/2">
              <input type="text" placeholder="Cari Kursus"
                     class="pl-10 pr-4 py-2 w-full rounded-lg border focus:ring-2 focus:ring-blue-500"
                     phx-debounce="500" phx-keyup="search">
            </div>
            <div class="relative w-full sm:w-auto">
              <select class="block appearance-none w-full bg-white border border-gray-300 py-2 px-4 pr-8 rounded-lg"
                      phx-change="filter">
                <option value="Semua Keputusan">Semua Keputusan</option>
                <option value="Diterima">Diterima</option>
                <option value="Dalam Proses">Dalam Proses</option>
                <option value="Ditolak">Ditolak</option>
              </select>
            </div>
          </div>

          <!-- Senarai Permohonan -->
          <div class="space-y-4">
            <%= for application <- @applications do %>
              <div class="bg-white p-6 rounded-lg shadow-sm flex flex-col md:flex-row justify-between items-start md:items-center">
                <div>
                  <h3 class="text-lg font-semibold"><%= application.kursus.nama_kursus %></h3>
                  <p class="text-sm text-gray-500">
                    Mohon: <%= application.inserted_at %>
                  </p>
                </div>

                <div class="mt-4 md:mt-0 flex flex-wrap gap-2 items-center">
                  <%= if application.status == "Diterima" do %>
                    <span class="px-3 py-1 text-xs font-semibold text-white bg-green-500 rounded-full">Diterima</span>
                    <a href={application.nota_kursus} class="btn-primary">Muat Turun Nota</a>
                    <a href={application.jadual_kursus} class="btn-primary">Muat Turun Jadual</a>
                  <% else %>
                    <%= if application.status == "Dalam Proses" do %>
                      <span class="px-3 py-1 text-xs font-semibold text-white bg-yellow-500 rounded-full">Dalam Proses</span>
                    <% else %>
                      <span class="px-3 py-1 text-xs font-semibold text-white bg-red-500 rounded-full">Ditolak</span>
                    <% end %>
                    <button class="btn-danger" phx-click="delete" phx-value-id={application.id}>Padam</button>
                  <% end %>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end

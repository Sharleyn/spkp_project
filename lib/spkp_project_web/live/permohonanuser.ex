defmodule SpkpProjectWeb.PermohonanUserLive do
  use SpkpProjectWeb, :live_view

  import Ecto.Query
  alias SpkpProject.Userpermohonan

   # ========== MOUNT ==========
    @impl true
    def mount(_params, _session, socket) do
      current_user = socket.assigns.current_user
      page = 1
      per_page = 10
      filter = "Semua Keputusan"

      {apps, has_more} =
        Userpermohonan.list_user_applications(current_user.id, filter, page, per_page)

      stats = Userpermohonan.get_user_stats(socket.assigns.current_user.id)
      {:noreply, assign(socket, applications: apps, has_more: has_more, stats: stats)}


      {:ok,
       socket
       |> assign(:current_user, current_user)
       |> assign(:current_user_name, current_user.full_name)
       |> assign(:sidebar_open, true)
       |> assign(:user_menu_open, false)
       |> assign(:applications, apps)
       |> assign(:stats, stats)
       |> assign(:filter, filter)
       |> assign(:page, page)
       |> assign(:per_page, per_page)
       |> assign(:has_more, has_more)}
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
            <h1 class="text-2xl font-bold">Permohonan Saya</h1>
             <p class="text-gray-500 mb-6">Temui kursus yang sesuai untuk meningkatkan kemahiran anda</p>

          <!-- Statistik -->
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">

            <div class="bg-sky-50 p-6 rounded-lg shadow flex flex-col items-center justify-center h-30">
              <h2 class="text-l font-semibold text-gray-600">Jumlah Permohonan</h2>
               <p class="text-2xl font-bold text-gray-900"><%= @stats.total %></p>
                <img src={~p"/images/paper.png"} alt="Paper Icon" class="w-8 h-8" />
            </div>

            <div class="bg-green-50 p-6 rounded-lg shadow flex flex-col items-center justify-center h-30">
              <h2 class="text-l font-semibold text-gray-600">Diterima</h2>
                <p class="text-2xl font-bold text-gray-900"><%= @stats.diterima %></p>
                  <img src={~p"/images/diterima.png"} alt="Diterima Icon" class="w-8 h-8" />
            </div>

            <div class="bg-orange-50 p-6 rounded-lg shadow flex flex-col items-center justify-center h-30">
              <h2 class="text-l font-semibold text-gray-600">Dalam Proses</h2>
                <p class="text-2xl font-bold text-gray-900"><%= @stats.dalam_proses %></p>
                  <img src={~p"/images/dalam_proses.png"} alt="Dalam Proses Icon" class="w-8 h-8" />
            </div>

            <div class="bg-red-50 p-6 rounded-lg shadow flex flex-col items-center justify-center h-30">
              <h2 class="text-l font-semibold text-gray-600">Ditolak</h2>
                <p class="text-2xl font-bold text-gray-900"><%= @stats.ditolak %></p>
                  <img src={~p"/images/ditolak.png"} alt="Ditolak Icon" class="w-8 h-8" />
            </div>
        </div>

          <!-- Search + Filter -->
          <div class="flex flex-col sm:flex-row items-center bg-sky-50 border border-gray-50 rounded-lg py-2 px-2 gap-4 mb-6">
            <div class="relative w-full sm:w-1/2">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                         <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                           <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" />
                        </svg>
                     </div>
              <input type="text" placeholder="Cari Nama Kursus"
                     class="pl-10 pr-4 py-2 w-full rounded-lg border focus:ring-2 focus:ring-blue-500"
                     phx-debounce="500" phx-keyup="search">
            </div>
            <div class="relative w-full sm:w-auto">
               <form phx-change="filter">
                 <select name="filter"
                   class="block appearance-none w-full bg-white border border-gray-300 py-2 px-4 pr-8 rounded-lg">
                     <option value="Semua Keputusan" selected={@filter == "Semua Keputusan"}>Semua Keputusan</option>
                     <option value="Diterima" selected={@filter == "Diterima"}>Diterima</option>
                     <option value="Dalam Proses" selected={@filter == "Dalam Proses"}>Dalam Proses</option>
                     <option value="Ditolak" selected={@filter == "Ditolak"}>Ditolak</option>
               </select>
             </form>
           </div>
          </div>

        <!-- Senarai Permohonan (Card Style) -->
          <div class="space-y-6">
             <%= for permohonan <- @applications do %>
                <div class="bg-[#FFFAFA] p-6 rounded-lg shadow-sm border-2 border-[#FFDAB9] hover:shadow-md transition">

          <!-- Header -->
             <div class="flex justify-between items-start">
                <div class="flex items-center space-x-2">

          <!-- Icon status -->
              <%= case permohonan.status do %>
                  <% "Diterima" -> %>
                    <.icon name="hero-check-circle" class="w-6 h-6 text-green-500" />
                  <% "Dalam Proses" -> %>
                    <.icon name="hero-clock" class="w-6 h-6 text-yellow-500" />
                  <% "Ditolak" -> %>
                    <.icon name="hero-x-circle" class="w-6 h-6 text-red-500" />
                  <% _ -> %>
                    <.icon name="hero-information-circle" class="w-6 h-6 text-gray-400" />
               <% end %>

          <!-- Nama kursus -->
            <h3 class="text-lg font-bold"><%= permohonan.kursus.nama_kursus %></h3>
          </div>

          <!-- Status Badge -->
            <span class={case permohonan.status do
              "Diterima" -> "px-3 py-1 rounded-full bg-green-100 text-green-700 text-sm font-semibold"
              "Dalam Proses" -> "px-3 py-1 rounded-full bg-yellow-100 text-yellow-700 text-sm font-semibold"
              "Ditolak" -> "px-3 py-1 rounded-full bg-red-100 text-red-700 text-sm font-semibold"
                 _ -> "px-3 py-1 rounded-full bg-gray-100 text-gray-700 text-sm font-semibold"
             end}>
              <%= permohonan.status %>
           </span>
         </div>

        <!-- Tarikh -->
           <p class="text-sm text-gray-500 font-medium mt-1">
              Mohon: <%= permohonan.inserted_at |> Calendar.strftime("%d-%m-%Y") %>
          </p>

        <!-- Butiran Kursus -->
           <div class="mt-4 text-sm text-gray-700 space-y-1">
             <p><strong>Tarikh Mula:</strong> <%= Calendar.strftime(permohonan.kursus.tarikh_mula, "%d-%m-%Y") %></p>
             <p><strong>Tarikh Akhir:</strong> <%= Calendar.strftime(permohonan.kursus.tarikh_akhir, "%d-%m-%Y") %></p>
             <p><strong>Tempat:</strong> <%= permohonan.kursus.tempat %></p>
             <p><strong>Anjuran:</strong> <%= permohonan.kursus.anjuran %></p>
           </div>

        <!-- Actions -->
           <div class="flex mt-4 gap-2">
              <!-- Nota -->
                 <%= cond do %>
                   <% permohonan.status != "Diterima" -> %>
                     <button disabled class="px-4 py-2 rounded-lg bg-gray-300 text-gray-600 cursor-not-allowed">
                       🚫 Nota Belum Boleh Dimuat Turun
                    </button>

                   <% is_nil(permohonan.kursus.nota_kursus) -> %>
                      <button disabled class="px-4 py-2 rounded-lg bg-yellow-200 text-yellow-800 cursor-not-allowed">
                        ⏳ Nota Belum Dimuat Naik
                      </button>

                   <% true -> %>
                      <a href={permohonan.kursus.nota_kursus}
                        class="px-4 py-2 rounded-lg bg-green-500 text-white font-bold hover:bg-green-600">
                         📄 Muat Turun Nota
                      </a>
                  <% end %>

              <!-- Jadual -->
                 <%= cond do %>
                    <% permohonan.status != "Diterima" -> %>
                       <button disabled class="px-4 py-2 rounded-lg bg-gray-300 text-gray-600 cursor-not-allowed">
                         🚫 Jadual Belum Boleh Dimuat Turun
                      </button>

                    <% is_nil(permohonan.kursus.jadual_kursus) -> %>
                       <button disabled class="px-4 py-2 rounded-lg bg-yellow-200 text-yellow-800 cursor-not-allowed">
                          ⏳ Jadual Belum Dimuat Naik
                      </button>

                    <% true -> %>
                       <a href={permohonan.kursus.jadual_kursus}
                         class="px-4 py-2 rounded-lg bg-green-500 text-white font-bold hover:bg-green-600">
                          🗓️ Muat Turun Jadual
                       </a>
                    <% end %>
                 </div>

                 <!-- ✅ Sijil (mesti masih dalam loop) -->
                     <div class="mt-4">
                       <%= cond do %>
                         <% permohonan.status != "Diterima" -> %>
                         <!-- Selain Diterima (Ditolak / Dalam Proses), jangan tunjuk apa-apa -->
                         <%= "" %>

                       <% Date.compare(permohonan.kursus.tarikh_akhir, Date.utc_today()) == :gt -> %>
                         <p class="italic text-gray-500 text-sm font-medium">
                           <i class="fa fa-hourglass-half text-yellow-500" aria-hidden="true"></i>
                              Sijil hanya tersedia selepas kursus tamat
                           </p>

                       <% is_nil(permohonan.certificate) or is_nil(permohonan.certificate.sijil_url) -> %>
                         <p class="italic text-gray-500 text-sm font-medium">
                           <i class="fa fa-exclamation-triangle text-red-500" aria-hidden="true"></i>
                              Sijil Belum Dimuat Naik
                         </p>

                       <% true -> %>
                          <a href={permohonan.certificate.sijil_url}
                            class="inline-flex items-center gap-2 px-4 py-2 rounded-lg bg-green-600 text-white font-bold hover:bg-green-700">
                             <i class="fa fa-check-square-o" aria-hidden="true"></i>
                               Muat Turun Sijil
                          </a>
                      <% end %>
                    </div>

                 </div>
               <% end %>



        <!-- Pagination -->
          <div class="flex justify-center mt-6 space-x-1">
            <button phx-click="prev_page"
              class="px-3 py-1 rounded-md border border-gray-300 bg-white text-gray-700 hover:bg-gray-100"
                disabled={@page == 1}>
                 &laquo; Prev
           </button>

          <span class="px-3 py-1 text-gray-700 font-medium">
             Page <%= @page %>
         </span>

          <button phx-click="next_page"
            class="px-3 py-1 rounded-md border border-gray-300 bg-white text-gray-700 hover:bg-gray-100"
             disabled={!@has_more}>
               Next &raquo;
         </button>
        </div>

        </div>
      </div>
    </div>
    """
  end

  @impl true
 # ========== EVENTS ==========
  def handle_event("filter", %{"filter" => filter}, socket) do
    {apps, has_more} =
      Userpermohonan.list_user_applications(
        socket.assigns.current_user.id,
        filter,
        socket.assigns.page,
        socket.assigns.per_page
      )

    {:noreply, assign(socket, applications: apps, filter: filter, has_more: has_more)}
  end

  def handle_event("search", %{"value" => term}, socket) do
    {apps, has_more} =
      Userpermohonan.search_user_applications(
        socket.assigns.current_user.id,
        term,
        socket.assigns.filter,
        socket.assigns.page,
        socket.assigns.per_page
      )

    {:noreply, assign(socket, applications: apps, has_more: has_more)}
  end

  def handle_event("next_page", _params, socket) do
    page = socket.assigns.page + 1
    {apps, has_more} =
      Userpermohonan.list_user_applications(
        socket.assigns.current_user.id,
        socket.assigns.filter,
        page,
        socket.assigns.per_page
      )

    {:noreply, assign(socket, applications: apps, page: page, has_more: has_more)}
  end

  def handle_event("prev_page", _params, socket) do
    page = max(socket.assigns.page - 1, 1)
    {apps, has_more} =
      Userpermohonan.list_user_applications(
        socket.assigns.current_user.id,
        socket.assigns.filter,
        page,
        socket.assigns.per_page
      )

    {:noreply, assign(socket, applications: apps, page: page, has_more: has_more)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    case Userpermohonan.delete_application(id) do
      {:ok, _} ->
        {apps, has_more} =
          Userpermohonan.list_user_applications(
            socket.assigns.current_user.id,
            socket.assigns.filter,
            socket.assigns.page,
            socket.assigns.per_page
          )

        {:noreply, assign(socket, applications: apps, has_more: has_more)}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Gagal memadam permohonan.")}
    end
  end

   # Toggle sidebar
   def handle_event("toggle_sidebar", _params, socket) do
    {:noreply, assign(socket, :sidebar_open, !socket.assigns.sidebar_open)}
  end

  # Toggle user menu
  def handle_event("toggle_user_menu", _params, socket) do
    {:noreply, assign(socket, :user_menu_open, !socket.assigns.user_menu_open)}
  end

  # Tutup user menu
  def handle_event("close_user_menu", _params, socket) do
    {:noreply, assign(socket, :user_menu_open, false)}
  end

  # Logout
  def handle_event("logout", _params, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Anda telah log keluar.")
     |> redirect(to: ~p"/lamanutama")}
  end

  # ========== HELPERS ==========
    defp nav_class(current, expected) do
      base = "flex items-center space-x-3 font-semibold p-3 rounded-xl transition-colors duration-200"
      if current == expected do
        base <> " bg-indigo-700 text-white"
      else
        base <> " hover:bg-indigo-700 text-gray-300"
      end
    end

# Filter
def list_user_applications(user_id, filter \\ "Semua Keputusan", page \\ 1, per_page \\ 10) do
  query =
    from(p in SpkpProject.Userpermohonan.Userpermohonan,
      where: p.user_id == ^user_id,
      join: k in assoc(p, :kursus),
      preload: [kursus: k],
      order_by: [desc: p.inserted_at]
    )

  query =
    case filter do
      "Diterima" -> from p in query, where: p.status == "Diterima"
      "Dalam Proses" -> from p in query, where: p.status == "Dalam Proses"
      "Ditolak" -> from p in query, where: p.status == "Ditolak"
      _ -> query
    end

  results =
    query
    |> limit(^(per_page + 1))
    |> offset(^(per_page * (page - 1)))
    |> SpkpProject.Repo.all()

  has_more = length(results) > per_page
  {Enum.take(results, per_page), has_more}
end



end

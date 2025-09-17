defmodule SpkpProjectWeb.SenaraiKursusLive do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Kursus.Kursuss
  alias SpkpProject.Userpermohonan.Userpermohonan
  alias SpkpProject.Repo

  import Ecto.Query

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    # Ambil semua kursus + preload kategori
    kursus = Repo.all(Kursuss) |> Repo.preload(:kursus_kategori)

    # Ambil senarai kursus_id yang user dah mohon
    applied_ids =
      from(p in Userpermohonan, where: p.user_id == ^current_user.id, select: p.kursus_id)
      |> Repo.all()

    # Senarai kategori unik
    categories =
      kursus
      |> Enum.map(& &1.kursus_kategori.kategori)
      |> Enum.uniq()

    # Pisah ikut tempoh
    jangka_panjang =
      Enum.filter(kursus, fn k -> Date.diff(k.tarikh_akhir, k.tarikh_mula) > 30 end)

    jangka_pendek =
      Enum.filter(kursus, fn k -> Date.diff(k.tarikh_akhir, k.tarikh_mula) <= 30 end)

    per_page = 5
    total = length(kursus)

    {:ok,
     socket
     |> assign(:kursus, kursus)
     |> assign(:jangka_panjang, jangka_panjang)
     |> assign(:jangka_pendek, jangka_pendek)
     |> assign(:categories, categories)
     |> assign(:search_query, "")
     |> assign(:selected_category, "")
     |> assign(:selected_type, "")
     |> assign(:current_user_name, current_user.full_name)
     |> assign(:sidebar_open, true)
     |> assign(:user_menu_open, false)

     # Pagination
     |> assign(:page, 1)
     |> assign(:per_page, per_page)
     |> assign(:total, total)
     |> assign(:total_pages, total_pages(total, per_page))}
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


      <!-- Main -->
             <h2 class="text-2xl font-bold text-gray-800">Senarai Kursus</h2>
             <p class="text-gray-500 mb-6">Temui kursus yang sesuai untuk meningkatkan kemahiran anda</p>

            <!-- Mula: Bar Carian & Penapis -->
              <div class="max-w-8xl mx-auto space-y-8 p-6">
                 <form phx-change="filter" phx-submit="search" class="bg-[#CDE2FB] bg-opacity-50 p-4 rounded-lg shadow-sm mb-8 flex flex-col md:flex-row gap-4 items-center">

                 <!-- Search Bar -->
                    <div class="relative w-full md:flex-1">
                      <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                         <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                           <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" />
                        </svg>
                     </div>

                     <input
                       type="text"
                       name="search_query"
                       value={@search_query}
                       placeholder="Cari nama kursus..."
                       class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md bg-white focus:ring-1 focus:ring-blue-500 sm:text-sm"
                      />
                     </div>

                 <!-- Dropdown Kategori -->
                    <div class="relative w-full md:w-auto">
                      <!-- Icon filter -->
                         <img src={~p"/images/filter.png"}
                              class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400"alt="Filter Icon" />

                      <!-- Dropdown -->
                         <select name="category"class="w-full pl-10 border-gray-300 rounded-md shadow-sm focus:border-blue-500 focus:ring-blue-500">
                            <option value="">Semua Kategori</option>
                               <%= for category <- @categories do %>
                                 <option value={category} selected={@selected_category == category}><%= category %></option>
                              <% end %>
                            </select>
                          </div>

                 <!-- Dropdown Jenis Kursus (Jangkan Panjang / Jangka Pendek) -->
                    <div class="w-full md:w-auto">
                       <select name="type" class="w-full border-gray-300 rounded-md shadow-sm focus:border-blue-500 focus:ring-blue-500">
                         <option value="">Semua Kursus</option>
                          <option value="Kursus Jangka Panjang" selected={@selected_type == "Kursus Jangka Panjang"}>Kursus Jangka Panjang</option>
                           <option value="Kursus Jangka Pendek" selected={@selected_type == "Kursus Jangka Pendek"}>Kursus Jangka Pendek</option>
                      </select>
                    </div>

                  <button type="submit" class="w-full md:w-auto bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">Cari</button>
                </form>
          <!-- Tamat: Bar Carian & Penapis -->

      <!-- Kalau Kursus Tiada -->

      <div class="max-w-8xl bg-[#F8F8FF] rounded-lg mx-auto space-y-8 p-6">
          <%= if Enum.empty?(@kursus) do %>
            <p class="text-gray-600">Tiada kursus yang tersedia pada saat ini.</p>
          <% else %>
            <%= for kursus <- paginated_courses(@kursus, @page, @per_page) do %>
            <div class="bg-white rounded-2xl shadow-lg p-6 grid grid-cols-1 md:grid-cols-3 gap-6">

            <!-- Bahagian Kiri: Logo & Gambar -->
            <div class="flex flex-col gap-4">
              <span class="bg-blue-500 text-white text-sm font-semibold px-4 py-1 rounded-full self-center">
                <%= kursus.kursus_kategori.kategori %>
              </span>
              <img src={kursus.gambar_kursus} alt="Gambar Kursus"
                   class="rounded-xl w-full h-auto object-cover" />
            </div>

            <!-- Bahagian Kanan: Maklumat Kursus -->
            <div class="md:col-span-2 bg-[#F8F8FF] rounded-lg border border-indigo-200 px-4 py-4 flex flex-col">
              <div class="flex justify-between items-start mb-1">
                <div>
                  <h3 class="text-xl font-bold text-gray-800"><%= kursus.nama_kursus %></h3>
                </div>

                <img src={kursus.gambar_anjuran} alt="Logo Penganjur"
                     class="w-16 h-16 rounded-full" />
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-x-6 text-gray-700">
                <p class="flex items-center gap-2">
                  <i class="fa fa-calendar" aria-hidden="true"></i>
                    <strong>Tarikh:</strong>
                      <%= Calendar.strftime(kursus.tarikh_mula, "%d-%m-%Y") %> hingga
                      <%= Calendar.strftime(kursus.tarikh_akhir, "%d-%m-%Y") %>
                </p>

                <p class="flex items-center gap-2">
                   <i class="fa fa-map-marker-alt" aria-hidden="true"></i>
                    <strong>Tempat:</strong> <%= kursus.tempat %>
                </p>

                <p class="flex items-center gap-2">
                   <i class="fa-solid fa-check-square" aria-hidden="true"></i>
                   <strong>Kuota:</strong> <%= kursus.kuota %>
                </p>

                <p class="flex items-center gap-2">
                   <i class="fas fa-clipboard" aria-hidden="true"></i>
                   <strong>Status:</strong> <%= kursus.status_kursus %></p>

                <p class="flex items-center gap-2">
                   <i class="fa fa-institution" aria-hidden="true"></i>
                   <strong>Tajaan:</strong> <%= kursus.anjuran %></p>

                <p class="flex items-center gap-1">
                   <i class="fa fa-desktop" aria-hidden="true"></i>
                   <strong>Kaedah:</strong> <%= kursus.kaedah %></p>

              </div>


          <!-- Main -->
              <div class="mt-4">
                 <h4 class="font-semibold text-gray-800 mb-2">Syarat Penyertaan</h4>

             <!-- Senarai syarat penyertaan -->
                 <ul class="list-disc list-inside text-sm text-gray-600 space-y-1">
                     <%= for syarat <- String.split(kursus.syarat_penyertaan || "", ["\n", "*"], trim: true) do %>
                        <li><%= String.trim(syarat) %></li>
                    <% end %>
               </ul>

             <!-- Syarat pendidikan -->
                 <p class="text-sm text-gray-700 mt-4">
                      <strong>Syarat Pendidikan:</strong> <%= kursus.syarat_pendidikan %>
                  </p>

             <!-- Had umur -->
                 <p class="text-sm text-gray-700 mt-1">
                      <strong>Had Umur:</strong> <%= kursus.had_umur %> tahun
                  </p>

             <!-- Tarikh Tutup Permohonan -->
                 <p class="text-sm text-gray-700 mt-4">
                      <strong>Tarikh Tutup Permohonan:</strong>
                       <%= Calendar.strftime(kursus.tarikh_tutup, "%d-%m-%Y") %>
                 </p>
              </div>

              <div class="mt-2 flex justify-end">
                <button phx-click="mohon" phx-value-kursus_id={kursus.id}
                        class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-lg">
                  Mohon
                </button>
               </div>
              </div>
             </div>
            <% end %>

           <!-- ✅ Pagination -->
                <div class="flex justify-center mt-6 space-x-1">
                  <!-- Prev Button -->
                     <button
                      phx-click="prev_page"
                       class="px-3 py-1 rounded-md border border-gray-300 bg-white text-gray-700 hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed"
                        disabled={@page == 1}>
                         &laquo; Prev
                     </button>

                  <!-- Current Page / Total Pages -->
                     <span class="px-3 py-1 text-gray-700 font-medium">
                        Page <%= @page %> of <%= @total_pages %>
                    </span>

                  <!-- Next Button -->
                     <button
                        phx-click="next_page"
                         class="px-3 py-1 rounded-md border border-gray-300 bg-white text-gray-700 hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed"
                          disabled={@page >= @total_pages}>
                           Next &raquo;
                    </button>
                 </div>
              <% end %>
             </div>
            </div>
           </div>
          </div>
    """
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

    # Bila user tekan "Cari"
  @impl true
  def handle_event("search", %{"search_query" => search, "category" => category, "type" => type}, socket) do
    kursus = filter_courses(search, category, type)
    total = length(kursus)
    per_page = socket.assigns.per_page
    {:noreply,
     socket
     |> assign(:kursus, kursus)
     |> assign(:search_query, search)
     |> assign(:selected_category, category)
     |> assign(:selected_type, type)
     |> assign(:total_pages, total_pages(total, per_page))
     |> assign(:total, total)    # ✅ update total
     |> assign(:page, 1)}        # ✅ reset ke page 1 bila search baru
  end

  # Bila user ubah search / filter
  @impl true
  def handle_event("filter", %{"search_query" => search, "category" => category, "type" => type}, socket) do
    kursus = filter_courses(search, category, type)
    total = length(kursus)
    per_page = socket.assigns.per_page
    {:noreply,
     socket
     |> assign(:kursus, kursus)
     |> assign(:search_query, search)
     |> assign(:selected_category, category)
     |> assign(:selected_type, type)
     |> assign(:total_pages, total_pages(total, per_page))
     |> assign(:total, total)    # ✅ update total
     |> assign(:page, 1)}        # ✅ reset ke page 1 bila filter berubah
  end

  def handle_event("next_page", _params, socket) do
    total_pages = div(socket.assigns.total + socket.assigns.per_page - 1, socket.assigns.per_page)
    new_page = min(socket.assigns.page + 1, total_pages)
    {:noreply, assign(socket, :page, new_page)}
  end

  def handle_event("prev_page", _params, socket) do
    new_page = max(socket.assigns.page - 1, 1)
    {:noreply, assign(socket, :page, new_page)}
  end

  def handle_event("pilih_kursus", %{"kursus" => value}, socket) do
    {:noreply, assign(socket, :kursus, value)}
    end

     # 👉 Handle klik "Mohon"
  def handle_event("mohon", %{"kursus_id" => kursus_id}, socket) do
    user_id = socket.assigns.current_user.id
    kursus_id = String.to_integer(kursus_id)

    case Userpermohonan.create_application(user_id, kursus_id) do
      {:ok, _application} ->
        {:noreply,
         socket
         |> put_flash(:info, "Permohonan berjaya dihantar.")
         |> assign(:applied_ids, [kursus_id | socket.assigns.applied_ids])}

      {:error, changeset} ->
        IO.inspect(changeset.errors, label: "❌ Gagal simpan")
        {:noreply, put_flash(socket, :error, "Gagal menghantar permohonan.")}
    end
  end

  # 🔍 Fungsi filter kursus
  defp filter_courses(search, category, type) do
    query =
      from k in Kursuss,
        join: c in assoc(k, :kursus_kategori),
        preload: [kursus_kategori: c],
        where: ilike(k.nama_kursus, ^"%#{search}%")

    query =
      if category != "" do
        from [k, c] in query, where: c.kategori == ^category
      else
        query
      end

    query =
      case type do
        "Kursus Jangka Panjang" ->
          from [k, _c] in query,
            where: fragment("? - ? > 30", k.tarikh_akhir, k.tarikh_mula)

        "Kursus Jangka Pendek" ->
          from [k, _c] in query,
            where: fragment("? - ? <= 30", k.tarikh_akhir, k.tarikh_mula)

        _ -> query
      end

    Repo.all(query)
  end

  # Pagination helpers
  defp paginated_courses(kursus, page, per_page) do
    kursus
    |> Enum.chunk_every(per_page)
    |> Enum.at(page - 1, [])
  end

  defp total_pages(total, per_page) do
    div(total + per_page - 1, per_page)
  end
end

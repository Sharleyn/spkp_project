defmodule SpkpProjectWeb.SidebarComponent do
  use Phoenix.LiveComponent
  use SpkpProjectWeb, :html

  @impl true
  def update(assigns, socket) do
    current_path = assigns[:current_path] || "/"

    # Tentukan menu mana perlu terbuka
    open_menu =
      cond do
        String.starts_with?(current_path, "/#{assigns.role}/dashboard") -> "dashboard"
        String.starts_with?(current_path, "/#{assigns.role}/kursus") -> "kursus"
        String.starts_with?(current_path, "/#{assigns.role}/peserta") -> "peserta"
        String.starts_with?(current_path, "/#{assigns.role}/permohonan") -> "permohonan"
        String.starts_with?(current_path, "/#{assigns.role}/elaun") -> "elaunpekerja"
        String.starts_with?(current_path, "/#{assigns.role}/tetapan") -> "tetapan"
        true -> nil
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:open_menu, open_menu)
     |> assign(:active_link, current_path)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-64 bg-blue-900 text-white">
      <!-- Logo Section -->
      <div class="p-6 border-b border-blue-800">
        <div class="flex items-center space-x-3">
          <div class="text-3xl">🎓</div>
          <div>
            <div class="font-bold text-lg">SPKP</div>
            <div class="text-sm text-blue-200">
              <%= if @role == "admin", do: "Admin Dashboard", else: "Pekerja Dashboard" %>
            </div>
          </div>
        </div>
      </div>

      <!-- Navigation Menu -->
      <nav class="p-4 flex-1 overflow-y-auto">
        <div class="text-sm font-semibold text-blue-300 mb-4">Menu Utama</div>

        <!-- Dashboard -->
        <.link
         navigate={if @role == "admin", do: ~p"/admin/dashboard", else: ~p"/pekerja/dashboard"}
         class={"flex items-center space-x-3 p-3 mb-2 rounded-lg hover:bg-blue-800 transition-colors duration-200 #{if @active_link == "/#{@role}/dashboard", do: "bg-blue-800 shadow-lg"}"}
        >
          <span class="text-xl">📊</span>
          <span>Dashboard</span>
        </.link>

        <!-- Kursus -->
        <div>
          <div
            phx-click="toggle_menu"
            phx-value-menu="kursus"
            phx-target={@myself}
            phx-stop-propagation
            class={"flex items-center space-x-3 p-3 mb-2 rounded-lg hover:bg-blue-800 transition-colors duration-200 cursor-pointer #{if @open_menu == "kursus", do: "bg-blue-800 shadow-lg"}"}
          >
            <span class="text-xl">🎓</span>
            <span>Kursus</span>
          </div>

          <%= if @open_menu == "kursus" do %>
            <div class="ml-4">
              <%= if @role == "admin" do %>
                <.link navigate={~p"/admin/kursus_kategori"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/admin/kursus_kategori", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">📂</span>
                  <span>Kategori Kursus</span>
                </.link>
                <.link navigate={~p"/admin/kursus"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/admin/kursus", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">📋</span>
                  <span>Senarai Kursus</span>
                </.link>
              <% else %>
                <.link navigate={~p"/pekerja/kursus_kategori"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/pekerja/kursus_kategori", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">📂</span>
                  <span>Kategori Kursus</span>
                </.link>
                <.link navigate={~p"/pekerja/kursus"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/pekerja/kursus", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">📋</span>
                  <span>Senarai Kursus</span>
                </.link>
              <% end %>
            </div>
          <% end %>
        </div>

        <!-- Permohonan -->
        <%= if @role == "admin" do %>
          <.link navigate={~p"/admin/permohonan"}
            class={"flex items-center space-x-3 p-3 mb-2 rounded-lg hover:bg-blue-800 transition-colors duration-200 #{if @active_link == "/admin/permohonan", do: "bg-blue-800 shadow-lg"}"}>
            <span class="text-xl">📝</span>
            <span>Permohonan</span>
          </.link>
        <% else %>
          <.link navigate={~p"/pekerja/permohonan"}
            class={"flex items-center space-x-3 p-3 mb-2 rounded-lg hover:bg-blue-800 transition-colors duration-200 #{if @active_link == "/pekerja/permohonan", do: "bg-blue-800 shadow-lg"}"}>
            <span class="text-xl">📝</span>
            <span>Permohonan</span>
          </.link>
        <% end %>

        <!-- Peserta -->
        <div>
          <div
            phx-click="toggle_menu"
            phx-value-menu="peserta"
            phx-target={@myself}
            phx-stop-propagation
            class={"flex items-center space-x-3 p-3 mb-2 rounded-lg hover:bg-blue-800 transition-colors duration-200 cursor-pointer #{if @open_menu == "peserta", do: "bg-blue-800 shadow-lg"}"}
          >
            <span class="text-xl">👥</span>
            <span>Peserta</span>
          </div>

          <%= if @open_menu == "peserta" do %>
            <div class="ml-4">
              <%= if @role == "admin" do %>
                <.link navigate={~p"/admin/peserta"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/admin/peserta", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">👤</span>
                  <span>Senarai Peserta</span>
                </.link>
              <% else %>
                <.link navigate={~p"/pekerja/peserta"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/pekerja/peserta", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">👤</span>
                  <span>Senarai Peserta</span>
                </.link>
              <% end %>
            </div>
          <% end %>
        </div>

        <!-- Elaun -->
        <div>
          <div
            phx-click="toggle_menu"
            phx-value-menu="elaunpekerja"
            phx-target={@myself}
            phx-stop-propagation
            class={"flex items-center space-x-3 p-3 mb-2 rounded-lg hover:bg-blue-800 transition-colors duration-200 cursor-pointer #{if @open_menu == "elaunpekerja", do: "bg-blue-800 shadow-lg"}"}
          >
            <span class="text-xl">💰</span>
            <span>Elaun</span>
          </div>

          <%= if @open_menu == "elaunpekerja" do %>
            <div class="ml-4">
              <%= if @role == "admin" do %>
                <.link navigate={~p"/admin/elaun_pekerja"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/admin/elaun_pekerja", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">📄</span>
                  <span>Senarai Tuntutan</span>
                </.link>
                <.link navigate={~p"/admin/item_elaun_pekerja"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/admin/item_elaun_pekerja", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">📋</span>
                  <span>Item Tuntutan Staff</span>
                </.link>
                <.link navigate={~p"/admin/maklumat_pekerja"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/admin/maklumat_pekerja", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">👨‍💼</span>
                  <span>Maklumat Staff</span>
                </.link>
              <% else %>
                <.link navigate={~p"/pekerja/elaun"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/pekerja/elaun_saya", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">📄</span>
                  <span>Tuntutan Saya</span>
                </.link>
                <.link navigate={~p"/pekerja/item_elaun_pekerja"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/pekerja/elaun_saya/baru", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">➕</span>
                  <span>Buat Tuntutan Baru</span>
                </.link>
                <.link navigate={~p"/pekerja/maklumat_saya"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/pekerja/maklumat_saya", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">👤</span>
                  <span>Maklumat Saya</span>
                </.link>
              <% end %>
            </div>
          <% end %>
        </div>

        <!-- Tetapan -->
        <div>
          <div
            phx-click="toggle_menu"
            phx-value-menu="tetapan"
            phx-target={@myself}
            phx-stop-propagation
            class={"flex items-center space-x-3 p-3 mb-2 rounded-lg hover:bg-blue-800 transition-colors duration-200 cursor-pointer #{if @open_menu == "tetapan", do: "bg-blue-800 shadow-lg"}"}
          >
            <span class="text-xl">⚙️</span>
            <span>Tetapan</span>
          </div>

          <%= if @open_menu == "tetapan" do %>
            <div class="ml-4">
              <%= if @role == "admin" do %>
                <.link navigate={~p"/admin/editprofile"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/admin/editprofile", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">✏️</span>
                  <span>Edit Profile</span>
                </.link>
                <.link navigate={~p"/admin/tukarkatalaluan"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/admin/tukarkatalaluan", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">🔒</span>
                  <span>Tukar Kata Laluan</span>
                </.link>
                <.link navigate={~p"/admin/assignstaff"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/admin/users", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">👥</span>
                  <span>Pengurusan Pengguna</span>
                </.link>
              <% else %>
                <.link navigate={~p"/pekerja/editprofile"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/pekerja/editprofile", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">✏️</span>
                  <span>Edit Profile</span>
                </.link>
                 <.link navigate={~p"/pekerja/tukarkatalaluan"}
                  class={"flex items-center space-x-2 p-2 mb-1 rounded-lg hover:bg-blue-700 text-sm #{if @active_link == "/pekerja/tukarkatalaluan", do: "bg-blue-700 font-bold shadow-md"}"}>
                  <span class="text-sm">🔒</span>
                  <span>Tukar Kata Laluan</span>
                </.link>
              <% end %>
            </div>
          <% end %>
        </div>
      </nav>
    </div>
    """
  end

  @impl true
  def handle_event("toggle_menu", %{"menu" => menu}, socket) do
    current_path = socket.assigns.active_link

    # Check if current path is within this menu's children
    is_child_active =
      case menu do
        "kursus" ->
          String.starts_with?(current_path, "/#{socket.assigns.role}/kursus")
        "peserta" ->
          String.starts_with?(current_path, "/#{socket.assigns.role}/peserta")
        "elaunpekerja" ->
          String.starts_with?(current_path, "/#{socket.assigns.role}/elaun") or
          String.starts_with?(current_path, "/#{socket.assigns.role}/item_elaun_pekerja") or
          String.starts_with?(current_path, "/#{socket.assigns.role}/maklumat_pekerja") or
          String.starts_with?(current_path, "/#{socket.assigns.role}/maklumat_saya")
        "tetapan" ->
          String.starts_with?(current_path, "/#{socket.assigns.role}/editprofile") or
          String.starts_with?(current_path, "/#{socket.assigns.role}/tukarkatalaluan") or
          String.starts_with?(current_path, "/#{socket.assigns.role}/assignstaff")
        _ ->
          String.starts_with?(current_path, "/#{socket.assigns.role}/#{menu}")
      end

    new_menu =
      cond do
        # Kalau memang sedang dalam route anak -> kekalkan open
        is_child_active ->
          menu

        # Kalau klik menu yang sama dan tiada child aktif -> tutup
        socket.assigns.open_menu == menu ->
          nil

        true ->
          menu
      end

    {:noreply, assign(socket, :open_menu, new_menu)}
  end
end

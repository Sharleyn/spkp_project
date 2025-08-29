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
        String.starts_with?(current_path, "/#{assigns.role}/elaun") -> "elaun"
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
         class={"block p-3 mb-2 rounded-lg hover:bg-gray-700 #{if @active_link == "/#{@role}/dashboard", do: "bg-gray-700"}"}
        >
         Dashboard
        </.link>

        <!-- Kursus -->
        <div>
          <div
            phx-click="toggle_menu"
            phx-value-menu="kursus"
            phx-target={@myself}
            class={"block p-3 mb-2 rounded-lg hover:bg-gray-700 cursor-pointer flex justify-between items-center #{if @open_menu == "kursus", do: "bg-gray-700"}"}
          >
            <span>Kursus</span>
          </div>

          <%= if @open_menu == "kursus" do %>
            <div class="ml-4">
                <%= if @role == "admin" do %>
              <.link
                navigate={~p"/admin/kursus_kategori"}
                class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/admin/kursus_kategori", do: "bg-gray-600 font-bold"}"}
              >
                Kategori Kursus
              </.link>
              <.link
                navigate={~p"/admin/kursus"}
                class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/admin/kursus", do: "bg-gray-600 font-bold"}"}
              >
                Senarai Kursus
              </.link>

              <% else %>
                  <.link
                    navigate={~p"/pekerja/kursus_kategori"}
                    class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/pekerja/kursus_kategori", do: "bg-gray-600 font-bold"}"}
                  >
                    Kategori Kursus
                  </.link>
                  <.link
                    navigate={~p"/pekerja/kursus"}
                    class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/pekerja/kursus", do: "bg-gray-600 font-bold"}"}
                  >
                    Senarai Kursus
                  </.link>
                <% end %>
            </div>
          <% end %>
        </div>

        <!-- Permohonan -->
       <%= if @role == "admin" do %>
           <.link
              navigate={~p"/admin/permohonan"}
                class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/admin/permohonan", do: "bg-gray-600 font-bold"}"}
            >
              Permohonan
              </.link>
              <% else %>
               <.link
                    navigate={~p"/pekerja/permohonan"}
                    class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/pekerja/permohonan", do: "bg-gray-600 font-bold"}"}
              >
          Permohonan
        </.link>
        <% end %>
        <!-- Peserta -->
        <div>
          <div
            phx-click="toggle_menu"
            phx-value-menu="peserta"
            phx-target={@myself}
            class={"block p-3 mb-2 rounded-lg hover:bg-gray-700 cursor-pointer flex justify-between items-center #{if @open_menu == "peserta", do: "bg-gray-700"}"}
          >
            <span>Peserta</span>
          </div>

          <%= if @open_menu == "peserta" do %>
            <div class="ml-4">
             <%= if @role == "admin" do %>
                  <.link
                    navigate={~p"/admin/senaraipeserta"}
                    class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/admin/senaraipeserta", do: "bg-gray-600 font-bold"}"}
              >
                Senarai Peserta
              </.link>
              <% else %>
                  <.link
                    navigate={~p"/pekerja/senaraipeserta"}
                    class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/pekerja/senaraipeserta", do: "bg-gray-600 font-bold"}"}
              >
              Senarai Peserta
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
              class={"block p-3 mb-2 rounded-lg hover:bg-gray-700 cursor-pointer flex justify-between items-center #{if @open_menu == "elaunpekerja", do: "bg-gray-700"}"}
            >
              <span>Elaun</span>
            </div>

            <%= if @open_menu == "elaunpekerja" do %>
              <div class="ml-4">
                <%= if @role == "admin" do %>
                  <.link
                    navigate={~p"/admin/elaun_pekerja"}
                    class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/admin/elaun_pekerja", do: "bg-gray-600 font-bold"}"}
                  >
                    Senarai Tuntutan
                  </.link>
                  <.link
                    navigate={~p"/admin/item_elaun_pekerja"}
                    class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/admin/item_elaun_pekerja", do: "bg-gray-600 font-bold"}"}
                  >
                    Buat Tuntutan Baru
                  </.link>
                  <.link
                    navigate={~p"/admin/maklumat_pekerja"}
                    class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/admin/maklumat_pekerja", do: "bg-gray-600 font-bold"}"}
                  >
                    Senarai Pekerja
                  </.link>
                <% else %>
                  <.link
                    navigate={~p"/pekerja/elaun_saya"}
                    class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/pekerja/elaun_saya", do: "bg-gray-600 font-bold"}"}
                  >
                    Tuntutan Saya
                  </.link>
                  <.link
                    navigate={~p"/pekerja/elaun_saya/baru"}
                    class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/pekerja/elaun_saya/baru", do: "bg-gray-600 font-bold"}"}
                  >
                    Buat Tuntutan Baru
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
            class={"block p-3 mb-2 rounded-lg hover:bg-gray-700 cursor-pointer flex justify-between items-center #{if @open_menu == "tetapan", do: "bg-gray-700"}"}
          >
            <span>Tetapan</span>
          </div>

          <%= if @open_menu == "tetapan" do %>
            <div class="ml-4">
              <.link
                navigate={~p"/#{@role}/editprofile"}
                class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/admin/tetapan/editprofile", do: "bg-gray-600 font-bold"}"}
              >
                Edit Profile
              </.link>

              <.link
                navigate={~p"/#{@role}/tukarkatalaluan"}
                class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/admin/tetapan/tukarkatalaluan", do: "bg-gray-600 font-bold"}"}
              >
                Tukar Kata Laluan
              </.link>

              <%= if @role == "admin" do %>
                <.link
                  navigate={~p"/admin/assignstaff"}
                  class={"block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm #{if @active_link == "/admin/users", do: "bg-gray-600 font-bold"}"}
                >
                  Pengurusan Pengguna
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
    new_menu = if socket.assigns.open_menu == menu, do: nil, else: menu
    {:noreply, assign(socket, :open_menu, new_menu)}
  end
end

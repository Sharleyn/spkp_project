defmodule SpkpProjectWeb.SidebarComponent do
  use Phoenix.LiveComponent
  use SpkpProjectWeb, :html

  @impl true
  def update(assigns, socket) do
    active_menu =
      cond do
        String.starts_with?(assigns.uri_path, "/admin/dashboard") -> "dashboard"
        String.starts_with?(assigns.uri_path, "/admin/kursus") -> "kursus"
        String.starts_with?(assigns.uri_path, "/admin/permohonan") -> "permohonan"
        String.starts_with?(assigns.uri_path, "/admin/peserta") -> "peserta"
        String.starts_with?(assigns.uri_path, "/admin/elaunpekerja") -> "elaunpekerja"
        String.starts_with?(assigns.uri_path, "/admin/tetapan") -> "tetapan"
        true -> nil
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:active_menu, active_menu)}
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
            <div class="text-sm text-blue-200">Admin Dashboard</div>
          </div>
        </div>
      </div>

      <!-- Navigation Menu -->
      <nav class="p-4">
        <div class="text-sm font-semibold text-blue-300 mb-4">Menu Utama</div>

        <!-- Dashboard -->
        <.link navigate={~p"/admin/dashboard"}
          class={"block p-3 mb-2 rounded-lg hover:bg-gray-700 #{if @active_menu == "dashboard", do: "bg-gray-700"}"}>
          Dashboard
        </.link>

        <!-- Kursus -->
        <div>
          <div phx-click="toggle_menu"
               phx-value-menu="kursus"
               phx-target={@myself}
               class={"block p-3 mb-2 rounded-lg hover:bg-gray-700 cursor-pointer flex justify-between items-center #{if @active_menu == "kursus", do: "bg-gray-700"}"}>
            <span>Kursus</span>
          </div>

          <%= if @active_menu == "kursus" do %>
            <div class="ml-4">
              <.link navigate={~p"/admin/kursus/senarai"} class="block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm">
                Senarai Kursus
              </.link>
              <.link navigate={~p"/admin/kursus/tambah"} class="block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm">
                Tambah Kursus
              </.link>
              <.link navigate={~p"/admin/kursus/kategori"} class="block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm">
                Kategori Kursus
              </.link>
            </div>
          <% end %>
        </div>

        <!-- Permohonan -->
        <.link navigate={~p"/admin/permohonan"}
          class={"block p-3 mb-2 rounded-lg hover:bg-gray-700 #{if @active_menu == "permohonan", do: "bg-gray-700"}"}>
          Permohonan
        </.link>

        <!-- Peserta -->
        <div>
          <div phx-click="toggle_menu"
               phx-value-menu="peserta"
               phx-target={@myself}
               class={"block p-3 mb-2 rounded-lg hover:bg-gray-700 cursor-pointer flex justify-between items-center #{if @active_menu == "peserta", do: "bg-gray-700"}"}>
            <span>Peserta</span>
          </div>

          <%= if @active_menu == "peserta" do %>
            <div class="ml-4">
              <.link navigate={~p"/admin/peserta/senaraipeserta"} class="block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm">
                Senarai Peserta
              </.link>
            </div>
          <% end %>
        </div>

        <!-- Elaun Pekerja -->
        <div>
          <div phx-click="toggle_menu"
               phx-value-menu="elaunpekerja"
               phx-target={@myself}
               class={"block p-3 mb-2 rounded-lg hover:bg-gray-700 cursor-pointer flex justify-between items-center #{if @active_menu == "elaunpekerja", do: "bg-gray-700"}"}>
            <span>Elaun Pekerja</span>
          </div>

          <%= if @active_menu == "elaunpekerja" do %>
            <div class="ml-4">
              <.link navigate={~p"/admin/elaunpekerja/senaraituntutan"} class="block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm">
                Senarai Tuntutan
              </.link>
              <.link navigate={~p"/admin/elaunpekerja/buattuntutanbaru"} class="block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm">
                Buat Tuntutan Baru
              </.link>
              <.link navigate={~p"/admin/elaunpekerja/senaraipekerja"} class="block p-2 mb-1 rounded-lg hover:bg-gray-600 text-sm">
                Senarai Pekerja
              </.link>
            </div>
          <% end %>
        </div>

        <!-- Tetapan -->
        <.link navigate={~p"/admin/tetapan"}
          class={"block p-3 mb-2 rounded-lg hover:bg-gray-700 #{if @active_menu == "tetapan", do: "bg-gray-700"}"}>
          Tetapan
        </.link>
      </nav>
    </div>
    """
  end

  @impl true
  def handle_event("toggle_menu", %{"menu" => menu}, socket) do
    new_menu = if socket.assigns.active_menu == menu, do: nil, else: menu
    {:noreply, assign(socket, :active_menu, new_menu)}
  end
end

defmodule SpkpProjectWeb.PekerjaElaunLive.Show do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Elaun
  alias SpkpProject.Repo


  @impl true
  def handle_params(%{"id" => id}, uri, socket) do
    elaun =
      Elaun.get_elaun_pekerja!(id)
      |> Repo.preload(:item_elaun_pekerja)

    today = Date.utc_today()
    can_edit = Date.compare(today, elaun.tarikh_mula) != :lt and Date.compare(today, elaun.tarikh_akhir) != :gt

    {:noreply,
    socket
    |> assign(:elaun, elaun)
    |> assign(:can_edit, can_edit)
    |> assign(:current_path, URI.parse(uri).path)}
  end

  @impl true
  def handle_event("add_item", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/pekerja/elaun/#{socket.assigns.elaun.id}/item_elaun_pekerja/new")}
  end

  @impl true
  def handle_event("edit_item", %{"id" => item_id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/pekerja/elaun/#{socket.assigns.elaun.id}/item_elaun_pekerja/#{item_id}/edit")}
  end

  @impl true
  def handle_event("save_draft", _params, socket) do
    case SpkpProject.Elaun.update_elaun_pekerja(socket.assigns.elaun, %{status_permohonan: "draft"}) do
      {:ok, elaun} ->
        {:noreply,
         socket
         |> assign(:elaun, elaun)
         |> put_flash(:info, "Draf disimpan")}
      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Gagal simpan draf")}
    end
  end


  def handle_event("submit", _params, socket) do
    case SpkpProject.Elaun.update_elaun_pekerja(socket.assigns.elaun, %{status_permohonan: "submitted"}) do
      {:ok, elaun} ->
        {:noreply,
         socket
         |> assign(:elaun, elaun)
         |> put_flash(:info, "Tuntutan dihantar")}
      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Gagal menghantar tuntutan")}
    end
  end


  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full min-h-screen bg-gray-100 flex">
      <!-- Sidebar -->
      <.live_component
        module={SpkpProjectWeb.SidebarComponent}
        id="sidebar"
        current_view={@socket.view}
        role={@current_user.role}
        current_user={@current_user}
        current_path={@current_path}
      />

      <!-- Main Content -->
      <div class="flex-1 flex flex-col">
        <.header class="bg-white shadow-sm border-b border-gray-200">
          <div class="flex justify-between items-center px-6 py-4">
            <div class="flex items-center space-x-4">
              <img src={~p"/images/a3.png"} alt="Logo" class="h-12" />
            </div>

            <div class="flex items-center space-x-4">
              <span class="text-gray-600"><%= @current_user.email %></span>
              <.link href={~p"/users/log_out"} method="delete" class="text-gray-600 hover:text-gray-800">
                Logout
              </.link>
              <div class="w-8 h-8 bg-gray-300 rounded-full"></div>
            </div>
          </div>

        </.header>

        <!-- Main Content -->
        <div class="flex-1 bg-white p-8">
          <!-- Title Section -->
          <div class="mb-8">
            <h1 class="text-3xl font-bold text-black mb-2">
              BORANG TUNTUTAN ELAUN BEKERJA
            </h1>
            <h2 class="text-2xl font-bold text-black mb-2">(BIASA)</h2>
            <h3 class="text-2xl font-bold text-black">SHARIF PERCHAYA SDN.BHD</h3>
          </div>

          <!-- Create New Claim Section -->
          <div class="mb-8">
            <h3 class="text-2xl font-bold text-black mb-4">BUAT TUNTUTAN BARU</h3>
            <div class="flex space-x-8">
              <div>
                <label class="block text-black font-semibold mb-2">Tarikh Mula</label>
                <input type="text" value={@elaun.tarikh_mula}
                       class="w-40 px-3 py-2 border border-black rounded bg-white text-black" readonly />
              </div>
              <div>
                <label class="block text-black font-semibold mb-2">Tarikh Akhir</label>
                <input type="text" value={@elaun.tarikh_akhir}
                       class="w-40 px-3 py-2 border border-black rounded bg-white text-black" readonly />
              </div>
            </div>
          </div>

          <!-- Claims List Section -->
          <div class="mb-8">
            <h3 class="text-xl font-bold text-black mb-4">SENARAI TUNTUTAN ELAUN</h3>

            <!-- Table -->
            <div class="border border-gray-400 rounded overflow-hidden">
              <!-- Table Header -->
              <div class="bg-gray-200 flex">
                <div class="flex-1 p-3 border-r border-gray-400">
                  <span class="text-black font-bold text-xs">KENYATAAN / JENIS KERJA</span>
                </div>
                <div class="flex-1 p-3 border-r border-gray-400">
                  <span class="text-black font-bold text-xs">TARIKH</span>
                </div>
                <div class="flex-1 p-3 border-r border-gray-400">
                  <span class="text-black font-bold text-xs">MASA MULA</span>
                </div>
                <div class="flex-1 p-3 border-r border-gray-400">
                  <span class="text-black font-bold text-xs">MASA TAMAT</span>
                </div>
                <div class="flex-1 p-3 border-r border-gray-400">
                  <span class="text-black font-bold text-xs">KETERANGAN</span>
                </div>
                <div class="flex-1 p-3 border-r border-gray-400">
                  <span class="text-black font-bold text-xs">JUMLAH</span>
                </div>
                <div class="flex-1 p-3">
                  <span class="text-black font-bold text-xs">TINDAKAN</span>
                </div>
              </div>

              <!-- Table Rows -->
              <%= for item <- @elaun.item_elaun_pekerja do %>
                <div class="bg-white flex border-b border-gray-400">
                  <div class="flex-1 p-3 border-r border-gray-400">
                    <span class="text-black text-xs"><%= item.kenyataan_tuntutan %></span>
                  </div>
                  <div class="flex-1 p-3 border-r border-gray-400">
                    <span class="text-black text-xs"><%= item.tarikh_tuntutan %></span>
                  </div>
                  <div class="flex-1 p-3 border-r border-gray-400">
                    <span class="text-black text-xs"><%= item.masa_mula %></span>
                  </div>
                  <div class="flex-1 p-3 border-r border-gray-400">
                    <span class="text-black text-xs"><%= item.masa_tamat %></span>
                  </div>
                  <div class="flex-1 p-3 border-r border-gray-400">
                    <span class="text-black text-xs"><%= item.keterangan %></span>
                  </div>
                  <div class="flex-1 p-3 border-r border-gray-400">
                    <span class="text-black text-xs">RM <%= item.jumlah %></span>
                  </div>
                  <div class="flex-1 p-3">
                  <%= if @elaun.status_permohonan == "draft" do %>
                    <button phx-click="edit_item" phx-value-id={item.id} class="bg-blue-600 text-white px-3 py-1 rounded text-xs hover:bg-blue-700">
                      Edit
                    </button>
                    <% else %>
                      <span class="text-gray-400 italic text-xs">Locked</span>
                    <% end %>
                  </div>
                </div>
              <% end %>
            </div>

            <!-- Add Item Button -->
            <%= if @elaun.status_permohonan == "draft" do %>
              <.link
                navigate={~p"/pekerja/elaun/#{@elaun.id}/item_elaun_pekerja/new"}
                class="mt-4 bg-white border border-gray-300 rounded-lg px-4 py-2 shadow-md hover:bg-gray-50"
              >
                <span class="text-black">+ tambah item</span>
              </.link>
            <% else %>
              <p class="mt-4 text-gray-500 italic">
                Tuntutan sudah dihantar, item tidak boleh ditambah
              </p>
            <% end %>
          </div>

          <!-- Action Buttons -->
          <div class="flex space-x-4">
          <%= if @elaun.status_permohonan == "draft" do %>
            <button phx-click="save_draft" class="bg-white border border-gray-300 rounded-lg px-6 py-2 shadow-md hover:bg-gray-50">
              <span class="text-black">Simpan sebagai draf</span>
            </button>
            <button phx-click="submit" class="bg-blue-600 text-white rounded-lg px-6 py-2 shadow-md hover:bg-blue-700">
              <span class="text-white">Hantar</span>
            </button>
            <% else %>
              <p class="text-gray-500 italic">Tuntutan telah dihantar dan tidak boleh diedit lagi</p>
            <% end %>

            <!-- ✅ Button Kembali -->
              <.link navigate={~p"/pekerja/elaun"}
                    class="bg-gray-500 text-white rounded-lg px-6 py-2 shadow-md hover:bg-gray-600">
                Kembali
              </.link>
          </div>
        </div>
      </div>
    </div>
    """
  end
end

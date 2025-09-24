defmodule SpkpProjectWeb.TuntutanSayaLive.Show do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Elaun

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    item = Elaun.get_item_elaun_pekerja!(id)

    {:noreply,
     socket
     |> assign(:item_elaun_pekerja, item)
     |> assign(:page_title, "Butiran Item Tuntutan")}
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
        current_path={~p"/pekerja/item_elaun_pekerja/#{@item_elaun_pekerja.id}"}
      />

      <!-- Main Content -->
      <div class="flex-1 flex flex-col p-10">
        <h2 class="text-2xl font-bold text-gray-900 mb-6">Butiran Item Tuntutan</h2>

        <div class="rounded-lg bg-white shadow p-6 space-y-4">
          <div>
            <label class="block text-sm text-gray-700">Kenyataan</label>
            <p class="text-gray-900"><%= @item_elaun_pekerja.kenyataan_tuntutan %></p>
          </div>

          <div>
            <label class="block text-sm text-gray-700">Tarikh Tuntutan</label>
            <p class="text-gray-900"><%= @item_elaun_pekerja.tarikh_tuntutan %></p>
          </div>

          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-sm text-gray-700">Masa Mula</label>
              <p class="text-gray-900"><%= @item_elaun_pekerja.masa_mula %></p>
            </div>
            <div>
              <label class="block text-sm text-gray-700">Masa Tamat</label>
              <p class="text-gray-900"><%= @item_elaun_pekerja.masa_tamat %></p>
            </div>
          </div>

          <div>
            <label class="block text-sm text-gray-700">Keterangan</label>
            <p class="text-gray-900"><%= @item_elaun_pekerja.keterangan %></p>
          </div>

          <div>
            <label class="block text-sm text-gray-700">Jumlah (RM)</label>
            <p class="text-gray-900"><%= @item_elaun_pekerja.jumlah %></p>
          </div>
        </div>

        <div class="mt-6 flex gap-4">
          <.link patch={~p"/pekerja/item_elaun_pekerja/#{@item_elaun_pekerja.id}/edit"}
                class="rounded bg-blue-600 px-4 py-2 text-white hover:bg-blue-700">
            Edit Item
          </.link>
          <.link navigate={~p"/pekerja/item_elaun_pekerja"}
                class="rounded bg-gray-500 px-4 py-2 text-white hover:bg-gray-600">
            Kembali
          </.link>
        </div>
      </div>
    </div>
    """
  end
end

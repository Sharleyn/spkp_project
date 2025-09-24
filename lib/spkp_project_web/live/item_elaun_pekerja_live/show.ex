defmodule SpkpProjectWeb.ItemElaunPekerjaLive.Show do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Elaun

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:item_elaun_pekerja, Elaun.get_item_elaun_pekerja!(id))}
  end

  defp page_title(:show), do: "Maklumat Item Elaun Pekerja"
  defp page_title(:edit), do: "Kemaskini Item Elaun Pekerja"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6 space-y-6">
      <!-- Header -->
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-2xl font-bold text-gray-800">
            {@page_title}
          </h1>
          <p class="text-gray-600 text-sm">ID Rekod: {@item_elaun_pekerja.id}</p>
        </div>

        <div class="flex gap-2">
          <.link
            patch={~p"/admin/item_elaun_pekerja/#{@item_elaun_pekerja}/show/edit"}
            phx-click={JS.push_focus()}
          >
            <.button class="bg-blue-600 hover:bg-blue-700 text-white">
              ✏️ Edit
            </.button>
          </.link>

          <.link
            navigate={~p"/admin/item_elaun_pekerja"}
          >
            <.button class="bg-gray-200 text-gray-700 hover:bg-gray-300">
              ← Kembali
            </.button>
          </.link>
        </div>
      </div>

      <!-- Detail Card -->
      <div class="bg-white rounded-lg shadow p-6">
        <dl class="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-4">
          <div>
            <dt class="text-sm font-medium text-gray-600">Kenyataan Tuntutan</dt>
            <dd class="mt-1 text-gray-900">{@item_elaun_pekerja.kenyataan_tuntutan}</dd>
          </div>

          <div>
            <dt class="text-sm font-medium text-gray-600">Tarikh Tuntutan</dt>
            <dd class="mt-1 text-gray-900">{@item_elaun_pekerja.tarikh_tuntutan}</dd>
          </div>

          <div>
            <dt class="text-sm font-medium text-gray-600">Masa Mula</dt>
            <dd class="mt-1 text-gray-900">{@item_elaun_pekerja.masa_mula}</dd>
          </div>

          <div>
            <dt class="text-sm font-medium text-gray-600">Masa Tamat</dt>
            <dd class="mt-1 text-gray-900">{@item_elaun_pekerja.masa_tamat}</dd>
          </div>

          <div class="md:col-span-2">
            <dt class="text-sm font-medium text-gray-600">Keterangan</dt>
            <dd class="mt-1 text-gray-900">{@item_elaun_pekerja.keterangan}</dd>
          </div>

          <div>
            <dt class="text-sm font-medium text-gray-600">Jumlah</dt>
            <dd class="mt-1 font-semibold text-green-600">RM {@item_elaun_pekerja.jumlah}</dd>
          </div>
        </dl>
      </div>
    </div>

    <!-- Edit Modal -->
    <.modal
      :if={@live_action == :edit}
      id="item_elaun_pekerja-modal"
      show
      on_cancel={JS.patch(~p"/admin/item_elaun_pekerja/#{@item_elaun_pekerja}")}
    >
      <.live_component
        module={SpkpProjectWeb.ItemElaunPekerjaLive.FormComponent}
        id={@item_elaun_pekerja.id}
        title={@page_title}
        action={@live_action}
        item_elaun_pekerja={@item_elaun_pekerja}
        patch={~p"/admin/item_elaun_pekerja/#{@item_elaun_pekerja}"}
      />
    </.modal>
    """
  end
end

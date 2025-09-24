defmodule SpkpProjectWeb.ElaunPekerjaLive.Show do
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
     |> assign(:elaun_pekerja, Elaun.get_elaun_pekerja!(id, [:item_elaun_pekerja, maklumat_pekerja: :user]))}
  end

  defp page_title(:show), do: "Maklumat Elaun Pekerja"
  defp page_title(:edit), do: "Edit Elaun Pekerja"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full min-h-screen bg-gray-100 flex">
      <!-- Main Content -->
      <div class="flex-1 flex flex-col">
        <!-- Header -->
        <.header class="bg-white shadow-sm border-b border-gray-200">
          <div class="flex justify-between items-center px-6 py-4">
            <h1 class="text-2xl font-bold text-gray-800">Maklumat Tuntutan Elaun</h1>
            <div>
              <.link patch={~p"/admin/elaun_pekerja/#{@elaun_pekerja}/show/edit"} phx-click={JS.push_focus()}>
                <.button>Edit</.button>
              </.link>
            </div>
          </div>
        </.header>

        <!-- Maklumat Elaun -->
        <div class="bg-white shadow rounded-lg p-6 m-6">
          <h2 class="text-lg font-semibold text-gray-700 mb-4">Maklumat Pekerja</h2>
          <.list>
            <:item title="Nama Penuh">{@elaun_pekerja.maklumat_pekerja.user.full_name}</:item>
            <:item title="Tarikh Mula">{@elaun_pekerja.tarikh_mula}</:item>
            <:item title="Tarikh Akhir">{@elaun_pekerja.tarikh_akhir}</:item>
            <:item title="Status Permohonan">{@elaun_pekerja.status_permohonan}</:item>
            <:item title="Jumlah Keseluruhan">RM {@elaun_pekerja.jumlah_keseluruhan}</:item>
          </.list>
        </div>

        <!-- Senarai Item Tuntutan -->
        <div class="bg-white shadow rounded-lg p-6 m-6">
          <h2 class="text-lg font-semibold text-gray-700 mb-4">Senarai Item Tuntutan</h2>

          <div class="overflow-x-auto border border-gray-300 rounded-lg">
            <table class="min-w-full border-collapse">
              <thead class="bg-gray-100">
                <tr class="text-left text-sm font-semibold text-gray-700">
                  <th class="p-3 border-b border-gray-300">Kenyataan</th>
                  <th class="p-3 border-b border-gray-300">Tarikh</th>
                  <th class="p-3 border-b border-gray-300">Masa Mula</th>
                  <th class="p-3 border-b border-gray-300">Masa Tamat</th>
                  <th class="p-3 border-b border-gray-300">Keterangan</th>
                  <th class="p-3 border-b border-gray-300 text-right">Jumlah (RM)</th>
                </tr>
              </thead>
              <tbody>
                <%= for item <- @elaun_pekerja.item_elaun_pekerja do %>
                  <tr class="text-sm text-gray-700 hover:bg-gray-50">
                    <td class="p-3 border-b border-gray-200"><%= item.kenyataan_tuntutan %></td>
                    <td class="p-3 border-b border-gray-200"><%= item.tarikh_tuntutan %></td>
                    <td class="p-3 border-b border-gray-200"><%= item.masa_mula %></td>
                    <td class="p-3 border-b border-gray-200"><%= item.masa_tamat %></td>
                    <td class="p-3 border-b border-gray-200"><%= item.keterangan %></td>
                    <td class="p-3 border-b border-gray-200 text-right">RM <%= item.jumlah %></td>
                  </tr>
                <% end %>
              </tbody>
              <tfoot class="bg-gray-50">
                <tr class="font-bold text-gray-800">
                  <td colspan="5" class="p-3 text-right">Jumlah Keseluruhan</td>
                  <td class="p-3 text-right">RM <%= @elaun_pekerja.jumlah_keseluruhan %></td>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>

          <!-- Back Button -->
          <div class="px-6 mb-6">
            <.link
              navigate={~p"/admin/elaun_pekerja"}
              class="inline-flex items-center px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
            >
              Kembali ke Senarai
            </.link>
          </div>

        <!-- Modal Edit -->
        <.modal :if={@live_action == :edit} id="elaun_pekerja-modal" show on_cancel={JS.patch(~p"/admin/elaun_pekerja/#{@elaun_pekerja}")}>
          <.live_component
            module={SpkpProjectWeb.ElaunPekerjaLive.FormComponent}
            id={@elaun_pekerja.id}
            title={@page_title}
            action={@live_action}
            elaun_pekerja={@elaun_pekerja}
            patch={~p"/admin/elaun_pekerja/#{@elaun_pekerja}"}
          />
        </.modal>
      </div>
    </div>
    """
  end
end

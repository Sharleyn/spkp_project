defmodule SpkpProjectWeb.PekerjaElaunLive.Show do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Elaun
  alias SpkpProject.Repo

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    elaun =
      Elaun.get_elaun_pekerja!(id)
      |> Repo.preload(:item_elaun_pekerja)

    {:noreply, assign(socket, elaun: elaun)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-xl font-bold mb-4">Butiran Elaun</h1>

      <.list>
        <:item title="Tarikh Mula">{@elaun.tarikh_mula}</:item>
        <:item title="Tarikh Akhir">{@elaun.tarikh_akhir}</:item>
        <:item title="Status">{@elaun.status_permohonan}</:item>
        <:item title="Jumlah Keseluruhan (RM)">{@elaun.jumlah_keseluruhan}</:item>
      </.list>

      <h2 class="text-lg font-semibold mt-6">Senarai Item</h2>
      <ul class="list-disc pl-6 mt-2 space-y-1">
        <%= for item <- @elaun.item_elaun_pekerja do %>
          <li>
            <span class="font-semibold"><%= item.kenyataan_tuntutan %></span>
            – RM <%= item.jumlah %>
          </li>
        <% end %>
      </ul>

      <div class="mt-6 flex gap-4">
        <.back navigate={~p"/pekerja/elaun"}>Kembali</.back>

        <.link navigate={~p"/pekerja/item_elaun_pekerja/#{@elaun.id}"}
               class="inline-flex items-center gap-2 rounded-md bg-blue-600 px-4 py-2
                      text-sm font-medium text-white shadow hover:bg-blue-700">
          Edit / Tambah Item
        </.link>
      </div>
    </div>
    """
  end
end

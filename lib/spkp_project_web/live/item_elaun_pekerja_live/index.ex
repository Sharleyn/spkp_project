defmodule SpkpProjectWeb.ItemElaunPekerjaLive.Index do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Elaun
  alias SpkpProject.Elaun.ItemElaunPekerja

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :item_elaun_pekerja_collection, Elaun.list_item_elaun_pekerja())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Item elaun pekerja")
    |> assign(:item_elaun_pekerja, Elaun.get_item_elaun_pekerja!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Item elaun pekerja")
    |> assign(:item_elaun_pekerja, %ItemElaunPekerja{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Item elaun pekerja")
    |> assign(:item_elaun_pekerja, nil)
  end

  @impl true
  def handle_info({SpkpProjectWeb.ItemElaunPekerjaLive.FormComponent, {:saved, item_elaun_pekerja}}, socket) do
    {:noreply, stream_insert(socket, :item_elaun_pekerja_collection, item_elaun_pekerja)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item_elaun_pekerja = Elaun.get_item_elaun_pekerja!(id)
    {:ok, _} = Elaun.delete_item_elaun_pekerja(item_elaun_pekerja)

    {:noreply, stream_delete(socket, :item_elaun_pekerja_collection, item_elaun_pekerja)}
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
      />
      <!-- Main Content -->
      <div class="flex-1 flex flex-col">
        <.header class="bg-white shadow-sm border-b border-gray-200">
          <div class="flex justify-between items-center px-6 py-4">
            <div class="flex items-center space-x-4">
              <div class="flex items-center gap-4">
                <img src={~p"/images/a3.png"} alt="Logo" class="h-12" />
              </div>

              <h1 class="text-xl font-semibold text-gray-800">SPKP Admin Dashboard</h1>
            </div>

            <div class="flex items-center space-x-4">
              <span class="text-gray-600">admin@gmail.com</span>

                  <.link href={~p"/users/log_out"} method="delete" class="text-gray-600 hover:text-gray-800">
              Logout
              </.link>

              <div class="w-8 h-8 bg-gray-300 rounded-full"></div>
            </div>
          </div>
        </.header>
        <!-- Page Header -->
        <div class="flex items-center justify-between mb-8 px-10 py-6">
          <div>
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Item Tuntutan</h1>

            <p class="text-gray-600">Tambah item tuntutan baru</p>
          </div>
           <.link patch={~p"/admin/elaun_pekerja/new"}><.button>Item tuntutan</.button></.link>
        </div>

    <.table
      id="item_elaun_pekerja"
      rows={@streams.item_elaun_pekerja_collection}
      row_click={fn {_id, item_elaun_pekerja} ->
        JS.navigate(~p"/admin/item_elaun_pekerja/#{item_elaun_pekerja}")
      end}
    >
      <:col :let={{_id, item_elaun_pekerja}} label="Kenyataan tuntutan">
        <%= item_elaun_pekerja.kenyataan_tuntutan %>
      </:col>
      <:col :let={{_id, item_elaun_pekerja}} label="Tarikh tuntutan">
        <%= item_elaun_pekerja.tarikh_tuntutan %>
      </:col>
      <:col :let={{_id, item_elaun_pekerja}} label="Masa mula">
        <%= item_elaun_pekerja.masa_mula %>
      </:col>
      <:col :let={{_id, item_elaun_pekerja}} label="Masa tamat">
        <%= item_elaun_pekerja.masa_tamat %>
      </:col>
      <:col :let={{_id, item_elaun_pekerja}} label="Keterangan">
        <%= item_elaun_pekerja.keterangan %>
      </:col>
      <:col :let={{_id, item_elaun_pekerja}} label="Jumlah">
        <%= item_elaun_pekerja.jumlah %>
      </:col>

      <:action :let={{_id, item_elaun_pekerja}}>
        <div class="sr-only">
          <.link navigate={~p"/admin/item_elaun_pekerja/#{item_elaun_pekerja}"}>Show</.link>
        </div>
        <.link patch={~p"/admin/item_elaun_pekerja/#{item_elaun_pekerja}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, item_elaun_pekerja}}>
        <.link
          phx-click={JS.push("delete", value: %{id: item_elaun_pekerja.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="item_elaun_pekerja-modal"
      show
      on_cancel={JS.patch(~p"/admin/item_elaun_pekerja")}
    >
      <.live_component
        module={SpkpProjectWeb.ItemElaunPekerjaLive.FormComponent}
        id={@item_elaun_pekerja.id || :new}
        title={@page_title}
        action={@live_action}
        item_elaun_pekerja={@item_elaun_pekerja}
        patch={~p"/admin/item_elaun_pekerja"}
      />
    </.modal>
    </div>
    </div>
    """
  end
end

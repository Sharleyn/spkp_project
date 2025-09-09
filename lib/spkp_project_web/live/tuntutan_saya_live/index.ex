defmodule SpkpProjectWeb.TuntutanSayaLive.Index do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Elaun
  alias SpkpProject.Elaun.ItemElaunPekerja

  @impl true
  def mount(_params, _session, socket) do
    items = Elaun.list_item_elaun_pekerja_by_user(socket.assigns.current_user.id)
    {:ok, stream(socket, :item_elaun_pekerja_collection, items)}
  end


  @impl true
  def handle_params(params, uri, socket) do
    {:noreply,
     socket
     |> assign(:current_path, URI.parse(uri).path)
     |> apply_action(socket.assigns.live_action, params)}
  end

  @impl true
  def handle_params(%{"id" => id, "live_action" => "edit"}, _uri, socket) do
    item = Elaun.get_item_elaun_pekerja!(id)
    |> SpkpProject.Repo.preload(:elaun_pekerja)

    {:noreply,
    socket
    |> assign(:page_title, "Edit Item Tuntutan Elaun")
    |> assign(:item_elaun_pekerja, item)}
  end


  defp apply_action(socket, :edit, %{"id" => id}) do
    item =
      Elaun.get_item_elaun_pekerja!(id)
      |> SpkpProject.Repo.preload(:elaun_pekerja)

    socket
    |> assign(:page_title, "Edit Item elaun pekerja")
    |> assign(:item_elaun_pekerja, item)
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
  def handle_info({SpkpProjectWeb.TuntutanSayaLive.FormComponent, {:saved, item}}, socket) do
    # masukkan item ke senarai pekerja
    socket = stream_insert(socket, :item_elaun_pekerja_collection, item)

    # ambil elaun_pekerja penuh + preload user
    elaun =
      Elaun.get_elaun_pekerja!(item.elaun_pekerja_id)
      |> SpkpProject.Repo.preload(:user)

    # hantar mesej supaya admin Index boleh tangkap
    send(self(), {:elaun_saved, elaun})

    {:noreply, socket}
  end


  # Atau versi generic
  # def handle_info({_, {:saved, item}}, socket) do
  #   {:noreply, stream_insert(socket, :item_elaun_pekerja_collection, item)}
  # end

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
          <.link patch={~p"/pekerja/item_elaun_pekerja/new"}
                class="inline-flex items-center gap-2 rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow hover:bg-blue-700">
            + Buat tuntutan baru
          </.link>
        </div>

        <.table
          id="item_elaun_pekerja"
          rows={@streams.item_elaun_pekerja_collection}
          row_click={fn {_id, item} -> JS.navigate(~p"/pekerja/item_elaun_pekerja/#{item}") end}
        >
          <:col :let={{_id, item}} label="Kenyataan tuntutan">
            <%= item.kenyataan_tuntutan %>
          </:col>
          <:col :let={{_id, item}} label="Tarikh tuntutan">
            <%= item.tarikh_tuntutan %>
          </:col>
          <:col :let={{_id, item}} label="Masa mula">
            <%= item.masa_mula %>
          </:col>
          <:col :let={{_id, item}} label="Masa tamat">
            <%= item.masa_tamat %>
          </:col>
          <:col :let={{_id, item}} label="Keterangan">
            <%= item.keterangan %>
          </:col>
          <:col :let={{_id, item}} label="Jumlah">
            <%= item.jumlah %>
          </:col>

          <:action :let={{_id, item}}>
            <div class="sr-only">
              <.link navigate={~p"/pekerja/item_elaun_pekerja/#{item}"}>Show</.link>
            </div>
            <.link patch={~p"/pekerja/item_elaun_pekerja/#{item}/edit"}>Edit</.link>
          </:action>

          <:action :let={{id, item}}>
            <.link
              phx-click={JS.push("delete", value: %{id: item.id}) |> hide("##{id}")}
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
          on_cancel={JS.patch(~p"/pekerja/item_elaun_pekerja")}
        >
          <.live_component
            module={SpkpProjectWeb.TuntutanSayaLive.FormComponent}
            id={@item_elaun_pekerja.id || :new}
            title={@page_title}
            action={@live_action}
            item_elaun_pekerja={@item_elaun_pekerja}
            patch={~p"/pekerja/item_elaun_pekerja"}
            current_user={@current_user}
          />
        </.modal>
      </div>
    </div>
    """
  end
end

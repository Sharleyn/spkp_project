defmodule SpkpProjectWeb.ElaunPekerjaLive.Index do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Elaun
  alias SpkpProject.Elaun.ElaunPekerja

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :elaun_pekerja_collection, Elaun.list_elaun_pekerja())}
  end

  @impl true
  def handle_params(params, uri, socket) do
    {:noreply,
    socket
    |> assign(:current_path, URI.parse(uri).path)
    |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Elaun pekerja")
    |> assign(:elaun_pekerja, Elaun.get_elaun_pekerja!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Elaun pekerja")
    |> assign(:elaun_pekerja, %ElaunPekerja{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Elaun pekerja")
    |> assign(:elaun_pekerja, nil)
  end

  @impl true
  def handle_info({SpkpProjectWeb.ElaunPekerjaLive.FormComponent, {:saved, elaun_pekerja}}, socket) do
    {:noreply, stream_insert(socket, :elaun_pekerja_collection, elaun_pekerja)}
  end

  @impl true
  def handle_info({:elaun_saved, elaun}, socket) do
    {:noreply, stream_insert(socket, :elaun_pekerja_collection, elaun)}
  end


  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    elaun_pekerja = Elaun.get_elaun_pekerja!(id)
    {:ok, _} = Elaun.delete_elaun_pekerja(elaun_pekerja)

    {:noreply, stream_delete(socket, :elaun_pekerja_collection, elaun_pekerja)}
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
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Senarai Tuntutan</h1>

            <p class="text-gray-600">Semak dan urus tuntutan elaun pekerja</p>
          </div>
           <.link patch={~p"/admin/elaun_pekerja/new"}><.button>Elaun Pekerja</.button></.link>
        </div>

    <.table
      id="elaun_pekerja"
      rows={@streams.elaun_pekerja_collection}
      row_click={fn {_id, elaun_pekerja} -> JS.navigate(~p"/admin/elaun_pekerja/#{elaun_pekerja}") end}
    >
      <:col :let={{_id, elaun_pekerja}} label="Nama Penuh">{elaun_pekerja.user.full_name}</:col>
      <:col :let={{_id, elaun_pekerja}} label="Tarikh mula">{elaun_pekerja.tarikh_mula}</:col>
      <:col :let={{_id, elaun_pekerja}} label="Tarikh akhir">{elaun_pekerja.tarikh_akhir}</:col>
      <:col :let={{_id, elaun_pekerja}} label="Status permohonan">{elaun_pekerja.status_permohonan}</:col>
      <:col :let={{_id, elaun_pekerja}} label="Jumlah keseluruhan">{elaun_pekerja.jumlah_keseluruhan}</:col>

      <:action :let={{_id, elaun_pekerja}}>
        <div class="sr-only">
          <.link navigate={~p"/admin/elaun_pekerja/#{elaun_pekerja}"}>Show</.link>
        </div>
        <.link patch={~p"/admin/elaun_pekerja/#{elaun_pekerja}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, elaun_pekerja}}>
        <.link
          phx-click={JS.push("delete", value: %{id: elaun_pekerja.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal :if={@live_action in [:new, :edit]} id="elaun_pekerja-modal" show on_cancel={JS.patch(~p"/admin/elaun_pekerja")}>
      <.live_component
        module={SpkpProjectWeb.ElaunPekerjaLive.FormComponent}
        id={@elaun_pekerja && @elaun_pekerja.id || :new}
        title={@page_title}
        action={@live_action}
        elaun_pekerja={@elaun_pekerja}
        patch={~p"/admin/elaun_pekerja"}
      />
    </.modal>
    </div>
    </div>
    """
  end
end

defmodule SpkpProjectWeb.MaklumatPekerjaLive.Index do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Accounts
  alias SpkpProject.Accounts.MaklumatPekerja

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :maklumat_pekerja_collection, Accounts.list_maklumat_pekerja())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Maklumat pekerja")
    |> assign(:maklumat_pekerja, Accounts.get_maklumat_pekerja!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Maklumat pekerja")
    |> assign(:maklumat_pekerja, %MaklumatPekerja{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Maklumat pekerja")
    |> assign(:maklumat_pekerja, nil)
  end

  @impl true
  def handle_info({SpkpProjectWeb.MaklumatPekerjaLive.FormComponent, {:saved, maklumat_pekerja}}, socket) do
    {:noreply, stream_insert(socket, :maklumat_pekerja_collection, maklumat_pekerja)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    maklumat_pekerja = Accounts.get_maklumat_pekerja!(id)
    {:ok, _} = Accounts.delete_maklumat_pekerja(maklumat_pekerja)

    {:noreply, stream_delete(socket, :maklumat_pekerja_collection, maklumat_pekerja)}
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
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Senarai Pekerja</h1>

            <p class="text-gray-600">Semak dan urus elaun pekerja</p>
          </div>
           <.link patch={~p"/admin/maklumat_pekerja/new"}><.button>Maklumat Pekerja</.button></.link>
        </div>

    <.table
      id="maklumat_pekerja"
      rows={@streams.maklumat_pekerja_collection}
      row_click={fn {_id, maklumat_pekerja} ->
        JS.navigate(~p"/admin/maklumat_pekerja/#{maklumat_pekerja}")
      end}
    >
      <:col :let={{_id, maklumat_pekerja}} label="Nama Penuh">{maklumat_pekerja.user.full_name}</:col>
      <:col :let={{_id, maklumat_pekerja}} label="Emel">{maklumat_pekerja.user.email}</:col>
      <:col :let={{_id, maklumat_pekerja}} label="No ic">{maklumat_pekerja.no_ic}</:col>
      <:col :let={{_id, maklumat_pekerja}} label="No tel">{maklumat_pekerja.no_tel}</:col>
      <:col :let={{_id, maklumat_pekerja}} label="Nama bank">{maklumat_pekerja.nama_bank}</:col>
      <:col :let={{_id, maklumat_pekerja}} label="No akaun">{maklumat_pekerja.no_akaun}</:col>

      <:action :let={{_id, maklumat_pekerja}}>
        <div class="sr-only">
          <.link navigate={~p"/admin/maklumat_pekerja/#{maklumat_pekerja}"}>Show</.link>
        </div>
        <.link patch={~p"/admin/maklumat_pekerja/#{maklumat_pekerja}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, maklumat_pekerja}}>
        <.link
          phx-click={JS.push("delete", value: %{id: maklumat_pekerja.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="maklumat_pekerja-modal"
      show
      on_cancel={JS.patch(~p"/admin/maklumat_pekerja")}
    >
      <.live_component
        module={SpkpProjectWeb.MaklumatPekerjaLive.FormComponent}
        id={@maklumat_pekerja.id || :new}
        title={@page_title}
        action={@live_action}
        maklumat_pekerja={@maklumat_pekerja}
        patch={~p"/admin/maklumat_pekerja"}
      />
    </.modal>
    </div>
    </div>
    """
  end
end

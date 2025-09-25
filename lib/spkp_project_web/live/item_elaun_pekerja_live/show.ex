defmodule SpkpProjectWeb.ItemElaunPekerjaLive.Show do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Elaun

  @impl true
  def mount(_params, _session, socket) do
    role = socket.assigns.current_user.role
    {:ok, assign(socket, :role, role)}
  end

  @impl true
  def handle_params(%{"id" => id}, uri, socket) do
    current_path =
      uri
      |> URI.parse()
      |> Map.get(:path)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:item_elaun_pekerja, Elaun.get_item_elaun_pekerja!(id))
     |> assign(:current_path, current_path)}
  end

  defp page_title(:show), do: "Maklumat Item Elaun Pekerja"
  defp page_title(:edit), do: "Kemaskini Item Elaun Pekerja"

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
              <h1 class="text-xl font-semibold text-gray-800"><%= if @role == "admin", do: "SPKP Admin Dashboard", else: "SPKP Pekerja Dashboard" %></h1>
            </div>

            <div class="flex items-center space-x-4">
              <span class="text-gray-600"><%= @current_user.full_name%></span>
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
            <p class="text-gray-600">Maklumat item elaun pekerja</p>
          </div>
          <div class="flex gap-2">
            <.link patch={~p"/admin/item_elaun_pekerja/#{@item_elaun_pekerja}/show/edit"} phx-click={JS.push_focus()}>
              <.button class="bg-blue-600 hover:bg-blue-700 text-white">✏️ Edit</.button>
            </.link>
            <.link navigate={~p"/admin/item_elaun_pekerja"}>
              <.button class="bg-gray-200 text-gray-700 hover:bg-gray-300">← Kembali</.button>
            </.link>
          </div>
        </div>

        <!-- Detail Card -->
        <div class="bg-white rounded-lg shadow p-6 mx-10 mb-10">
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

        <!-- Modal Edit -->
        <.modal :if={@live_action == :edit} id="item_elaun_pekerja-modal" show on_cancel={JS.patch(~p"/admin/item_elaun_pekerja/#{@item_elaun_pekerja}")}>
          <.live_component
            module={SpkpProjectWeb.ItemElaunPekerjaLive.FormComponent}
            id={@item_elaun_pekerja.id}
            title={@page_title}
            action={@live_action}
            item_elaun_pekerja={@item_elaun_pekerja}
            patch={~p"/admin/item_elaun_pekerja/#{@item_elaun_pekerja}"}
          />
        </.modal>
      </div>
    </div>
    """
  end
end

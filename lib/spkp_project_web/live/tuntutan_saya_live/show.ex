defmodule SpkpProjectWeb.TuntutanSayaLive.Show do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Elaun
  alias SpkpProject.Elaun.ItemElaunPekerja

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:show_form, false)
     |> assign(:selected_item, nil)
     |> assign(:form_action, nil)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    elaun = Elaun.get_elaun_pekerja!(id, preload: [:item_elaun_pekerja])

    {:noreply,
     socket
     |> assign(:elaun_pekerja, elaun)
     |> assign(:page_title, "Borang Tuntutan Elaun")}
  end

  # bila klik tambah item
  @impl true
  def handle_event("new_item", _, socket) do
    {:noreply,
     socket
     |> assign(:show_form, true)
     |> assign(:form_action, :new)
     |> assign(:selected_item, %ItemElaunPekerja{})}
  end

  # bila klik edit
  @impl true
  def handle_event("edit_item", %{"id" => id}, socket) do
    item = Elaun.get_item_elaun_pekerja!(id)

    {:noreply,
     socket
     |> assign(:show_form, true)
     |> assign(:form_action, :edit)
     |> assign(:selected_item, item)}
  end

  # bila lepas simpan, hide balik form
  @impl true
  def handle_info({SpkpProjectWeb.TuntutanSayaLive.FormComponent, {:saved, _item}}, socket) do
    elaun =
      Elaun.get_elaun_pekerja!(socket.assigns.elaun_pekerja.id,
        preload: [:item_elaun_pekerja]
      )

    {:noreply,
     socket
     |> assign(:elaun_pekerja, elaun)
     |> assign(:show_form, false)
     |> assign(:selected_item, nil)}
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
        current_path={~p"/pekerja/item_elaun_pekerja/#{@elaun_pekerja.id}"}
      />

      <!-- Main Content -->
      <div class="flex-1 flex flex-col">
        <!-- Header -->
        <.header class="bg-white shadow-sm border-b border-gray-200">
          <div class="flex justify-between items-center px-6 py-4">
            <div class="flex items-center space-x-4">
              <img src={~p"/images/a3.png"} alt="Logo" class="h-12" />
              <h1 class="text-2xl font-semibold text-gray-900">Dashboard Admin Kursus</h1>
            </div>
            <div class="flex items-center space-x-4">
              <span class="text-gray-600">admin@gmail.com</span>
              <.link href={~p"/users/log_out"} method="delete" class="text-gray-600 hover:text-gray-800">Logout</.link>
              <div class="w-8 h-8 bg-gray-300 rounded-full"></div>
            </div>
          </div>
        </.header>

        <!-- Title -->
        <div class="px-10 pt-10">
          <h2 class="text-center text-2xl font-serif text-gray-900 leading-tight">
            BORANG TUNTUTAN ELAUN BEKERJA<br/>(BIASA)
          </h2>
          <p class="text-center mt-2 font-serif text-gray-900">SHARIF PERCHAYA SDN.BHD</p>
        </div>

        <!-- Card -->
        <div class="px-10 py-8">
          <div class="rounded-xl bg-white shadow border border-gray-200 p-6">
            <!-- Buat tuntutan baru -->
            <h3 class="text-lg font-semibold text-gray-900">BUAT TUNTUTAN BARU</h3>

            <div class="mt-4 grid grid-cols-1 sm:grid-cols-2 gap-6 max-w-xl">
              <div>
                <label class="block text-sm text-gray-700 mb-2">Tarikh Mula</label>
                <div class="rounded-md border border-gray-300 px-3 py-2 bg-white text-gray-900">
                  <%= @elaun_pekerja.tarikh_mula %>
                </div>
              </div>
              <div>
                <label class="block text-sm text-gray-700 mb-2">Tarikh Akhir</label>
                <div class="rounded-md border border-gray-300 px-3 py-2 bg-white text-gray-900">
                  <%= @elaun_pekerja.tarikh_akhir %>
                </div>
              </div>
            </div>

            <!-- Senarai -->
            <h3 class="mt-8 text-lg font-semibold text-gray-900">SENARAI TUNTUTAN ELAUN</h3>

            <div class="mt-4 overflow-x-auto">
              <table class="min-w-full divide-y divide-gray-300 border border-gray-300 rounded-md">
                <thead class="bg-gray-50">
                  <tr>
                    <th class="px-4 py-2 text-left text-xs font-semibold text-gray-700">KENYATAAN / JENIS KERJA</th>
                    <th class="px-4 py-2 text-left text-xs font-semibold text-gray-700">TARIKH</th>
                    <th class="px-4 py-2 text-left text-xs font-semibold text-gray-700">MASA MULA</th>
                    <th class="px-4 py-2 text-left text-xs font-semibold text-gray-700">MASA TAMAT</th>
                    <th class="px-4 py-2 text-left text-xs font-semibold text-gray-700">KETERANGAN</th>
                    <th class="px-4 py-2 text-left text-xs font-semibold text-gray-700">JUMLAH</th>
                    <th class="px-4 py-2 text-left text-xs font-semibold text-gray-700">TINDAKAN</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200 bg-white">
                  <%= for item <- @elaun_pekerja.item_elaun_pekerja do %>
                    <tr>
                      <td class="px-4 py-2 text-sm text-gray-900"><%= item.jenis_kerja %></td>
                      <td class="px-4 py-2 text-sm text-gray-900"><%= item.tarikh %></td>
                      <td class="px-4 py-2 text-sm text-gray-900"><%= item.masa_mula %></td>
                      <td class="px-4 py-2 text-sm text-gray-900"><%= item.masa_tamat %></td>
                      <td class="px-4 py-2 text-sm text-gray-900"><%= item.keterangan %></td>
                      <td class="px-4 py-2 text-sm text-gray-900">RM <%= item.jumlah %></td>
                      <td class="px-4 py-2 text-sm">
                        <button class="rounded bg-blue-600 px-3 py-1 text-white hover:bg-blue-700"
                                phx-click="edit_item" phx-value-id={item.id}>Edit</button>
                      </td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>

            <!-- Actions -->
            <div class="mt-6 flex flex-col sm:flex-row sm:items-center gap-4">
              <button phx-click="new_item" class="inline-flex items-center gap-2 rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50">
                + tambah item
              </button>
              <button type="button" class="inline-flex items-center gap-2 rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50">
                Simpan sebagai draf
              </button>
              <button type="button" class="ml-auto inline-flex items-center gap-2 rounded-md bg-blue-600 px-5 py-2 text-sm font-medium text-white shadow hover:bg-blue-700">
                Hantar
              </button>
            </div>
          </div>
        </div>

        <%= if @show_form do %>
          <.live_component
            module={SpkpProjectWeb.TuntutanSayaLive.FormComponent}
            id="item-form"
            action={@form_action}
            item={@selected_item}
            elaun_pekerja={@elaun_pekerja}
          />
        <% end %>
      </div>
    </div>
    """
  end
end

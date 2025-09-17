defmodule SpkpProjectWeb.ItemElaunPekerjaLive.Index do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Elaun
  alias SpkpProject.Elaun.ItemElaunPekerja

  @impl true
  def mount(_params, _session, socket) do
    result = Elaun.list_item_elaun_pekerja_paginated(1, 5)

    {:ok,
     socket
     |> assign(:item_elaun_pekerja_collection, result.data)
     |> assign(:page, result.page)
     |> assign(:total_pages, result.total_pages)
     |> assign(:per_page, result.per_page)
     |> assign(:query, "")}  # <<< untuk simpan nilai search
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
    {:noreply,
     assign(socket, :item_elaun_pekerja_collection,
       [item_elaun_pekerja | socket.assigns.item_elaun_pekerja_collection]
     )}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item_elaun_pekerja = Elaun.get_item_elaun_pekerja!(id)
    {:ok, _} = Elaun.delete_item_elaun_pekerja(item_elaun_pekerja)

    {:noreply,
     assign(socket, :item_elaun_pekerja_collection,
       Enum.reject(socket.assigns.item_elaun_pekerja_collection, fn i -> i.id == item_elaun_pekerja.id end)
     )}
  end

  @impl true
  def handle_event("goto_page", %{"page" => page}, socket) do
    page = String.to_integer(page)

    results =
      if socket.assigns.query == "" do
        Elaun.list_item_elaun_pekerja_paginated(page, socket.assigns.per_page)
      else
        Elaun.search_item_elaun_pekerja(socket.assigns.query, page, socket.assigns.per_page)
      end

    {:noreply,
     socket
     |> assign(:item_elaun_pekerja_collection, results.data)
     |> assign(:page, results.page)
     |> assign(:total_pages, results.total_pages)}
  end


  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    results =
      if query == "" do
        Elaun.list_item_elaun_pekerja_paginated(1, socket.assigns.per_page)
      else
        Elaun.search_item_elaun_pekerja(query, 1, socket.assigns.per_page) # <<< buat function ni dalam context Elaun
      end

    {:noreply,
    socket
    |> assign(:query, query)
    |> assign(:item_elaun_pekerja_collection, results.data)
    |> assign(:page, results.page)
    |> assign(:total_pages, results.total_pages)}
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
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Item Tuntutan</h1>
            <p class="text-gray-600">Tambah item tuntutan baru</p>
          </div>
          <.link patch={~p"/admin/elaun_pekerja/new"}><.button>Item tuntutan</.button></.link>
        </div>

        <!-- Search bar -->
        <div class="flex justify-start px-20">
          <form phx-change="search" class="w-full">
            <input
              type="text"
              name="q"
              value={@query}
              placeholder="Cari item elaun pekerja..."
              class="w-full px-4 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring focus:border-blue-300"
            />
          </form>
        </div>


        <!-- Table -->
        <.table
          id="item_elaun_pekerja"
          rows={@item_elaun_pekerja_collection}
          row_click={fn item -> JS.navigate(~p"/admin/item_elaun_pekerja/#{item.id}") end}
        >
          <:col :let={item} label="Kenyataan tuntutan"><%= item.kenyataan_tuntutan %></:col>
          <:col :let={item} label="Tarikh tuntutan"><%= item.tarikh_tuntutan %></:col>
          <:col :let={item} label="Masa mula"><%= item.masa_mula %></:col>
          <:col :let={item} label="Masa tamat"><%= item.masa_tamat %></:col>
          <:col :let={item} label="Keterangan"><%= item.keterangan %></:col>
          <:col :let={item} label="Jumlah"><%= item.jumlah %></:col>
        </.table>

        <!-- Pagination -->
        <div class="flex justify-center mt-4 space-x-2">
          <!-- Prev -->
          <%= if @page > 1 do %>
            <button
              phx-click="goto_page"
              phx-value-page={@page - 1}
              class="px-3 py-1 rounded border bg-white text-gray-700 hover:bg-gray-100"
            >
              Prev
            </button>
          <% end %>

          <!-- Page Numbers -->
          <%= for p <- 1..@total_pages do %>
            <button
              phx-click="goto_page"
              phx-value-page={p}
              class={
                "px-3 py-1 rounded border " <>
                  if(p == @page, do: "bg-blue-600 text-white", else: "bg-white text-gray-700")
              }
            >
              <%= p %>
            </button>
          <% end %>

          <!-- Next -->
          <%= if @page < @total_pages do %>
            <button
              phx-click="goto_page"
              phx-value-page={@page + 1}
              class="px-3 py-1 rounded border bg-white text-gray-700 hover:bg-gray-100"
            >
              Next
            </button>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end

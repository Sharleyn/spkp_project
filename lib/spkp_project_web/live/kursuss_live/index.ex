defmodule SpkpProjectWeb.KursussLive.Index do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Kursus
  alias SpkpProject.Kursus.Kursuss

  @impl true
  def mount(_params, _session, socket) do
    result = Kursus.list_kursus_paginated(1, 5)

    # inisialisasi stream :kursus dengan data halaman pertama
    socket =
      socket
      |> stream(:kursus, result.data)
      |> assign(:page, result.page)
      |> assign(:total_pages, result.total_pages)
      |> assign(:per_page, result.per_page)
      |> assign(:query, "")
      |> assign(:kursuss, nil)
      # jika masih perlukan kursus_collection untuk logik lain, boleh assign juga:
      |> assign(:kursus_collection, result.data)

    {:ok, socket}
  end


  @impl true
  def handle_params(params, uri, socket) do
    return_to = Map.get(params, "return_to")

    {:noreply,
    socket
    |> assign(:current_path, URI.parse(uri).path)
    |> assign(:return_to, return_to) # simpan nilai return_to
    |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Kursus")
    |> assign(:kursuss, Kursus.get_kursuss!(id))
    |> assign(:kursus_kategori, Kursus.list_kursus_kategori())
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Kursus")
    |> assign(:kursuss, %Kursuss{})
    |> assign(:kursus_kategori, Kursus.list_kursus_kategori())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Kursus")
    |> assign(:kursuss, nil)
    |> assign(:kursus_kategori, [])
  end

  @impl true
  def handle_info({SpkpProjectWeb.KursussLive.FormComponent, {:saved, kursuss}}, socket) do
    {:noreply, stream_insert(socket, :kursus, kursuss)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    kursuss = Kursus.get_kursuss!(id)
    {:ok, _} = Kursus.delete_kursuss(kursuss)

    {:noreply, stream_delete(socket, :kursus, kursuss)}
  end

  @impl true
  def handle_event("goto_page", %{"page" => page}, socket) do
    page = String.to_integer(page)

    results =
      if socket.assigns.query == "" do
        Kursus.list_kursus_paginated(page, socket.assigns.per_page)
      else
        Kursus.search_kursus(socket.assigns.query, page, socket.assigns.per_page)
      end

    socket =
      socket
      |> stream(:kursus, results.data, reset: true)   # set semula stream mengikut page baru
      |> assign(:page, results.page)
      |> assign(:total_pages, results.total_pages)
      |> assign(:kursus_collection, results.data) # optional

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    results =
      if query == "" do
        Kursus.list_kursus_paginated(1, socket.assigns.per_page)
      else
        Kursus.search_kursus(query, 1, socket.assigns.per_page)
      end

    socket =
      socket
      |> stream(:kursus, results.data, reset: true)   # set semula stream hasil carian
      |> assign(:query, query)
      |> assign(:page, results.page)
      |> assign(:total_pages, results.total_pages)
      |> assign(:kursus_collection, results.data) # optional

    {:noreply, socket}
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
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Senarai Kursus</h1>

            <p class="text-gray-600">Semak dan urus semua kursus dan penambahan kursus baru</p>
          </div>
           <.link patch={~p"/admin/kursus/new"}><.button>Kursus Baru</.button></.link>
        </div>


        <!-- Search bar -->
        <div class="flex justify-start px-20">
          <form phx-change="search" class="w-full">
            <input
              type="text"
              name="q"
              value={@query}
              placeholder="Cari kursus..."
              class="w-full px-4 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring focus:border-blue-300"
            />
          </form>
        </div>

        <!-- Table -->
        <.table
          id="kursus"
          rows={@streams.kursus}
          row_click={fn {_id, kursuss} -> JS.navigate(~p"/admin/kursus/#{kursuss}") end}
        >
          <:col :let={{_id, kursuss}} label="Nama kursus">{kursuss.nama_kursus}</:col>

          <:col :let={{_id, kursuss}} label="Tarikh mula">{kursuss.tarikh_mula}</:col>

          <:col :let={{_id, kursuss}} label="Tarikh akhir">{kursuss.tarikh_akhir}</:col>

          <:col :let={{_id, kursuss}} label="Status kursus">{kursuss.status_kursus}</:col>
          <:col :let={{_id, kursuss}} label="Kaedah Pembelajaran">{kursuss.kaedah}</:col>

          <:col :let={{_id, kursuss}} label="Anjuran">{kursuss.anjuran}</:col>

          <:col :let={{_id, kursuss}} label="Kuota">{kursuss.kuota}</:col>
          <!-- Kolum gambar -->
          <:col :let={{_id, kursuss}} label="Gambar Anjuran">
            <div class="flex gap-2">
              <%= if kursuss.gambar_anjuran do %>
                <img
                  src={kursuss.gambar_anjuran}
                  alt="Gambar Anjuran"
                  class="w-16 h-16 rounded-lg object-cover border"
                />
              <% else %>
                <span class="text-gray-400 text-xs">Tiada anjuran</span>
              <% end %>
            </div>
          </:col>

          <:col :let={{_id, kursuss}} label="Gambar Kursus">
            <div class="flex gap-2">
              <%= if kursuss.gambar_kursus do %>
                <img
                  src={kursuss.gambar_kursus}
                  alt="Gambar Kursus"
                  class="w-16 h-16 rounded-lg object-cover border"
                />
              <% else %>
                <span class="text-gray-400 text-xs">Tiada kursus</span>
              <% end %>
            </div>
          </:col>

          <:action :let={{_id, kursuss}}>
            <div class="sr-only"><.link navigate={~p"/admin/kursus/#{kursuss}"}>Show</.link></div>
             <.link patch={~p"/admin/kursus/#{kursuss}/edit"}>Edit</.link>
          </:action>

          <:action :let={{id, kursuss}}>
            <.link
              phx-click={JS.push("delete", value: %{id: kursuss.id}) |> hide("##{id}")}
              data-confirm="Are you sure?"
            >
              Delete
            </.link>
          </:action>
        </.table>

        <!-- Pagination -->
        <div class="flex justify-center mt-6 space-x-2">
          <!-- Prev -->
          <button
            phx-click="goto_page"
            phx-value-page={@page - 1}
            class="px-3 py-1 rounded border bg-white text-gray-700 disabled:opacity-50"
            disabled={@page <= 1}
          >
            Prev
          </button>

          <!-- Page numbers -->
          <%= for p <- 1..@total_pages do %>
            <button
              phx-click="goto_page"
              phx-value-page={p}
              class={"px-3 py-1 rounded border " <>
                if(p == @page, do: "bg-blue-600 text-white", else: "bg-white text-gray-700")}
            >
              <%= p %>
            </button>
          <% end %>

          <!-- Next -->
          <button
            phx-click="goto_page"
            phx-value-page={@page + 1}
            class="px-3 py-1 rounded border bg-white text-gray-700 disabled:opacity-50"
            disabled={@page >= @total_pages}
          >
            Next
          </button>
        </div>

        <.modal
          :if={@live_action in [:new, :edit]}
          id="kursuss-modal"
          show
          on_cancel={JS.patch(@return_to || ~p"/admin/kursus")}
        >
          <.live_component
            module={SpkpProjectWeb.KursussLive.FormComponent}
            id={@kursuss.id || :new}
            title={@page_title}
            action={@live_action}
            kursuss={@kursuss}
            patch={@return_to || ~p"/admin/kursus"}
          />
        </.modal>
      </div>
    </div>
    """
  end
end

defmodule SpkpProjectWeb.ElaunPekerjaLive.Index do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Elaun
  alias SpkpProject.Elaun.ElaunPekerja

  @impl true
  def mount(_params, _session, socket) do
    result = Elaun.list_elaun_pekerja_paginated(1,5, true)

    {:ok,
     socket
     |> assign(:elaun_pekerja_collection, result.data)
     |> assign(:page, result.page)
     |> assign(:total_pages, result.total_pages)
     |> assign(:per_page, result.per_page)
     |> assign(:elaun_pekerja, nil)
     |> assign(:query, "")   # <<< Tambah ini
     |> assign(:page_title, "Listing Elaun pekerja")}
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
    {:noreply,
     update(socket, :elaun_pekerja_collection, fn list ->
       [elaun_pekerja | list]
     end)}
  end

  @impl true
  def handle_info({:elaun_saved, elaun}, socket) do
    {:noreply,
     update(socket, :elaun_pekerja_collection, fn list ->
       [elaun | list]
     end)}
  end



  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    elaun_pekerja = Elaun.get_elaun_pekerja!(id)
    {:ok, _} = Elaun.delete_elaun_pekerja(elaun_pekerja)

    {:noreply,
     update(socket, :elaun_pekerja_collection, fn list ->
       Enum.reject(list, fn e -> e.id == elaun_pekerja.id end)
     end)}
  end

  @impl true
  def handle_event("goto_page", %{"page" => page}, socket) do
    page = String.to_integer(page)

    results =
      if socket.assigns.query == "" do
        Elaun.list_elaun_pekerja_paginated(page, socket.assigns.per_page, true)
      else
        Elaun.search_elaun_pekerja(socket.assigns.query, page, socket.assigns.per_page)
      end

    {:noreply,
     socket
     |> assign(:elaun_pekerja_collection, results.data)
     |> assign(:page, results.page)
     |> assign(:total_pages, results.total_pages)}
  end


  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    results =
      if query == "" do
        Elaun.list_elaun_pekerja_paginated(1, socket.assigns.per_page, true)
      else
        Elaun.search_elaun_pekerja(query, 1, socket.assigns.per_page, true)
      end

    {:noreply,
    socket
    |> assign(:query, query)
    |> assign(:elaun_pekerja_collection, results.data)
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
            <div class="flex items-center gap-4">
              <img src={~p"/images/a3.png"} alt="Logo" class="h-12" />
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
        </div>

          <!-- Search bar -->
          <div class="flex justify-start px-20 ">
            <form phx-change="search" class="w-full">
              <input
                type="text"
                name="q"
                value={@query}
                placeholder="Cari nama pekerja..."
                class="w-full px-4 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring focus:border-blue-300"
              />
            </form>
          </div>


        <!-- Table -->
        <.table
          id="elaun_pekerja"
          rows={@elaun_pekerja_collection}
          row_click={fn elaun_pekerja -> JS.navigate(~p"/admin/elaun_pekerja/#{elaun_pekerja}") end}
        >
          <:col :let={elaun_pekerja} label="Nama Penuh">{elaun_pekerja.maklumat_pekerja.user.full_name}</:col>
          <:col :let={elaun_pekerja} label="Tarikh mula">{elaun_pekerja.tarikh_mula}</:col>
          <:col :let={elaun_pekerja} label="Tarikh akhir">{elaun_pekerja.tarikh_akhir}</:col>
          <:col :let={elaun_pekerja} label="Status permohonan">{elaun_pekerja.status_permohonan}</:col>
          <:col :let={elaun_pekerja} label="Jumlah keseluruhan">{elaun_pekerja.jumlah_keseluruhan}</:col>

          <:action :let={elaun_pekerja}>
            <.link patch={~p"/admin/elaun_pekerja/#{elaun_pekerja}/edit"}>Edit</.link>
          </:action>

          <:action :let={elaun_pekerja}>
            <.link
              phx-click={JS.push("delete", value: %{id: elaun_pekerja.id})}
              data-confirm="Are you sure?"
            >
              Delete
            </.link>
          </:action>
        </.table>

        <!-- Pagination -->
        <div class="flex justify-center mt-6 space-x-2">
          <!-- Prev button -->
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
              class={
                "px-3 py-1 rounded border " <>
                  if(p == @page, do: "bg-blue-600 text-white", else: "bg-white text-gray-700")
              }
            >
              <%= p %>
            </button>
          <% end %>


          <!-- Next button -->
          <button
            phx-click="goto_page"
            phx-value-page={@page + 1}
            class="px-3 py-1 rounded border bg-white text-gray-700 disabled:opacity-50"
            disabled={@page >= @total_pages}
          >
            Next
          </button>
        </div>

        <!-- Modal -->
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

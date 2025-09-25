defmodule SpkpProjectWeb.TuntutanSayaLive.Index do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Elaun
  alias SpkpProject.Elaun.ItemElaunPekerja

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    result = Elaun.list_item_elaun_pekerja_by_user_paginated(user_id, 1, 5)

    {:ok,
     socket
     |> assign(:item_elaun_pekerja_collection, result.data)
     |> assign(:page, result.page)
     |> assign(:total_pages, result.total_pages)
     |> assign(:per_page, result.per_page)
     |> assign(:page_title, "Senarai Item Elaun")
     |> assign(:elaun, nil)
     |> assign(:item_elaun_pekerja, nil)
     |> assign(:query, "")
     |> assign(:search_date, "")
     |> assign(:role, socket.assigns.current_user.role)}
  end

  @impl true
  def handle_params(params, uri, socket) do
    socket =
      case socket.assigns.live_action do
        :new_elaun ->
          socket
          |> assign(:elaun, nil)
          |> assign(:page_title, "Elaun baru")
          |> assign(:item_elaun_pekerja, nil)

        :new_item ->
          elaun = Elaun.get_elaun_pekerja!(params["elaun_id"])

          socket
          |> assign(:elaun, elaun)
          |> assign(:page_title, "Tambah Item Elaun")
          |> assign(:item_elaun_pekerja, %ItemElaunPekerja{})

        :edit ->
          item =
            Elaun.get_item_elaun_pekerja!(params["id"])
            |> SpkpProject.Repo.preload(:elaun_pekerja)

          socket
          |> assign(:elaun, item.elaun_pekerja)
          |> assign(:item_elaun_pekerja, item)
          |> assign(:page_title, "Edit Item Elaun")

        :index ->
          socket
          |> assign(:page_title, "Senarai Item Elaun")
          |> assign(:item_elaun_pekerja, nil)

        _ ->
          socket
      end

    {:noreply, assign(socket, :current_path, URI.parse(uri).path)}
  end

  @impl true
  def handle_info({SpkpProjectWeb.TuntutanSayaLive.ElaunFormComponent, {:saved, _elaun}}, socket) do
    user_id = socket.assigns.current_user.id

    result =
      Elaun.list_item_elaun_pekerja_by_user_paginated(
        user_id,
        socket.assigns.page,
        socket.assigns.per_page
      )

    {:noreply,
     socket
     |> assign(:item_elaun_pekerja_collection, result.data)
     |> assign(:total_pages, result.total_pages)
     # tutup modal dengan patch ke index (optional)
     |> push_patch(to: ~p"/pekerja/item_elaun_pekerja")}
  end


  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item = Elaun.get_item_elaun_pekerja!(id)
    {:ok, _} = Elaun.delete_item_elaun_pekerja(item)

    user_id = socket.assigns.current_user.id
    result =
      Elaun.list_item_elaun_pekerja_by_user_paginated(
        user_id,
        socket.assigns.page,
        socket.assigns.per_page
      )

    {:noreply,
     socket
     |> assign(:item_elaun_pekerja_collection, result.data)
     |> assign(:total_pages, result.total_pages)}
  end

  @impl true
  def handle_event("goto_page", %{"page" => page}, socket) do
    page = String.to_integer(page)
    user_id = socket.assigns.current_user.id
    result =
      Elaun.list_item_elaun_pekerja_by_user_paginated(
        user_id,
        page,
        socket.assigns.per_page
      )

    {:noreply,
     socket
     |> assign(:item_elaun_pekerja_collection, result.data)
     |> assign(:page, result.page)
     |> assign(:total_pages, result.total_pages)}
  end

  @impl true
  def handle_event("search", %{"q" => query, "date" => date}, socket) do
    user_id = socket.assigns.current_user.id

    # parse tarikh jika ada; format expected: "YYYY-MM-DD"
    date_filter =
      case date do
        nil -> nil
        "" -> nil
        d ->
          case Date.from_iso8601(d) do
            {:ok, dt} -> dt
            _ -> nil
          end
      end

    results =
      # gunakan satu fungsi context yang fleksibel: query (string or ""), date (Date or nil)
      Elaun.search_item_elaun_pekerja_by_user(user_id, query || "", date_filter, 1, socket.assigns.per_page)

    {:noreply,
    socket
    |> assign(:query, query || "")
    |> assign(:search_date, date || "")
    |> assign(:item_elaun_pekerja_collection, results.data)
    |> assign(:page, results.page)
    |> assign(:total_pages, results.total_pages)}
  end

  # backward compatibility: if phx-change sends only q (older clients)
  def handle_event("search", %{"q" => query}, socket) do
    handle_event("search", %{"q" => query, "date" => socket.assigns.search_date || ""}, socket)
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
            <p class="text-gray-600">Tambah item tuntutan baru</p>
          </div>
          <.link patch={~p"/pekerja/elaun/new"}
                 class="inline-flex items-center gap-2 rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow hover:bg-blue-700">
            + Buat Elaun Baru
          </.link>
        </div>

       <!-- Search bar -->
        <div class="flex justify-start px-20">
          <form phx-change="search" class="w-full flex flex-col sm:flex-row gap-3 items-center">
            <!-- Search text (ambil ruang lebihan) -->
            <input
              type="text"
              name="q"
              value={@query}
              placeholder="Cari item tuntutan..."
              phx-debounce="300"
              class="flex-1 w-full px-4 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring focus:border-blue-300"
            />

            <!-- Tarikh di tepi (fixed width pada desktop) -->
            <input
              type="date"
              name="date"
              value={@search_date || ""}
              class="w-full sm:w-48 px-3 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring focus:border-blue-300"
              title="Cari mengikut tarikh tuntutan (YYYY-MM-DD)"
            />
          </form>
        </div>


        <!-- Table (styled like kursus kategori) -->
        <div class="px-10 pt-4 w-full">
          <table class="w-full border border-gray-300 rounded-lg shadow-lg text-center">
            <thead>
              <tr class="bg-blue-900 text-white">
                <th class="px-4 py-3">Kenyataan tuntutan</th>
                <th class="px-4 py-3">Tarikh tuntutan</th>
                <th class="px-4 py-3">Masa mula</th>
                <th class="px-4 py-3">Masa tamat</th>
                <th class="px-4 py-3">Keterangan</th>
                <th class="px-4 py-3">Jumlah</th>
                <th class="px-4 py-3">Tindakan</th>
              </tr>
            </thead>

            <tbody>
              <%= for item <- @item_elaun_pekerja_collection do %>
                <tr
                  class="border-b cursor-pointer transition duration-200 ease-in-out hover:scale-[1.01] hover:shadow-md hover:bg-gray-100"
                  phx-click={JS.navigate(~p"/pekerja/item_elaun_pekerja/#{item.id}")}
                >
                  <td class="px-4 py-3"><%= item.kenyataan_tuntutan %></td>
                  <td class="px-4 py-3"><%= item.tarikh_tuntutan %></td>
                  <td class="px-4 py-3"><%= item.masa_mula %></td>
                  <td class="px-4 py-3"><%= item.masa_tamat %></td>
                  <td class="px-4 py-3"><%= item.keterangan %></td>
                  <td class="px-4 py-3"><%= item.jumlah %></td>
                  <td class="px-4 py-3 space-x-3" phx-click="noop">
                    <%= if @elaun do %>
                      <.link patch={~p"/pekerja/elaun/#{@elaun.id}?action=edit_item&id_item=#{item.id}"} class="text-blue-600 font-medium hover:underline">Edit</.link>
                    <% end %>
                    <.link phx-click={JS.push("delete", value: %{id: item.id})} data-confirm="Are you sure?" class="text-red-600 font-medium hover:underline">Delete</.link>
                  </td>
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center mt-4 space-x-2">
          <button
            :if={@page > 1}
            phx-click="goto_page"
            phx-value-page={@page - 1}
            class="px-3 py-1 rounded border bg-white text-gray-700 hover:bg-gray-200"
          >
            Prev
          </button>

          <%= for p <- 1..@total_pages do %>
            <button
              phx-click="goto_page"
              phx-value-page={p}
              class={
                "px-3 py-1 rounded border " <>
                if(p == @page, do: "bg-blue-600 text-white", else: "bg-white text-gray-700 hover:bg-gray-200")
              }
            >
              <%= p %>
            </button>
          <% end %>

          <button
            :if={@page < @total_pages}
            phx-click="goto_page"
            phx-value-page={@page + 1}
            class="px-3 py-1 rounded border bg-white text-gray-700 hover:bg-gray-200"
          >
            Next
          </button>
        </div>

        <!-- Modal: Elaun Form (shown when live_action == :new_elaun) -->
        <%= if @live_action == :new_elaun do %>
          <.live_component
            module={SpkpProjectWeb.TuntutanSayaLive.ElaunFormComponent}
            id="elaun_form"
            current_user={@current_user}
          />
        <% end %>
      </div>
    </div>
    """
  end
end

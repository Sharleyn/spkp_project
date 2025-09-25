defmodule SpkpProjectWeb.KursussLive.Index do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Kursus
  alias SpkpProject.Kursus.Kursuss

  @impl true
  def mount(_params, _session, socket) do
    role = socket.assigns.current_user.role
    result = Kursus.list_kursus_paginated(1, 5)

    socket =
      socket
      |> assign(:role, role)
      |> stream(:kursus, result.data)
      |> assign(:page, result.page)
      |> assign(:total_pages, result.total_pages)
      |> assign(:per_page, result.per_page)
      |> assign(:query, "")
      |> assign(:kursuss, nil)
      |> assign(:kursus_collection, result.data)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, uri, socket) do
    return_to = Map.get(params, "return_to")

    {:noreply,
     socket
     |> assign(:current_path, URI.parse(uri).path)
     |> assign(:return_to, return_to)
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
    return_to = socket.assigns.return_to
    patch_url = if socket.assigns.role == "admin" do
      return_to || ~p"/admin/kursus"
    else
      return_to || ~p"/pekerja/kursus"
    end

    {:noreply,
     socket
     |> stream_insert(:kursus, kursuss)
     |> assign(:kursuss, nil)
     |> push_patch(to: patch_url)}
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
      |> stream(:kursus, results.data, reset: true)
      |> assign(:page, results.page)
      |> assign(:total_pages, results.total_pages)
      |> assign(:kursus_collection, results.data)

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
      |> stream(:kursus, results.data, reset: true)
      |> assign(:query, query)
      |> assign(:page, results.page)
      |> assign(:total_pages, results.total_pages)
      |> assign(:kursus_collection, results.data)

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
            <img src={~p"/images/a3.png"} alt="Logo" class="h-12" />
            <h1 class="text-xl font-semibold text-gray-800">
              <%= if @role == "admin", do: "SPKP Admin Dashboard", else: "SPKP Pekerja Dashboard" %>
            </h1>
          </div>

          <div class="flex items-center space-x-4">
            <span class="text-gray-600"><%= @current_user.full_name %></span>
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

        <.link patch={
          if @role == "admin",
            do: ~p"/admin/kursus/new",
            else: ~p"/pekerja/kursus/new"
        }>
          <.button class="bg-blue-700 hover:bg-blue-800 text-white">Kursus Baru</.button>
        </.link>
      </div>

      <!-- Search bar -->
      <div class="flex justify-start px-20 mb-6">
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

      <!-- ✅ Table -->
      <div class="px-10 w-full">
        <table class="w-full border border-gray-300 rounded-lg shadow-lg text-center">
          <thead>
            <tr class="bg-blue-900 text-white">
              <th class="px-4 py-3">Nama Kursus</th>
              <th class="px-4 py-3">Tarikh Mula</th>
              <th class="px-4 py-3">Tarikh Akhir</th>
              <th class="px-4 py-3">Status</th>
              <th class="px-4 py-3">Kaedah</th>
              <th class="px-4 py-3">Anjuran</th>
              <th class="px-4 py-3">Kuota</th>
              <th class="px-4 py-3">Gambar Anjuran</th>
              <th class="px-4 py-3">Gambar Kursus</th>
              <th class="px-4 py-3">Tindakan</th>
            </tr>
          </thead>

          <tbody>
            <%= for {_id, kursus} <- @streams.kursus do %>
              <tr
                class="border-b cursor-pointer transition duration-200 ease-in-out hover:scale-[1.01] hover:shadow-md hover:bg-gray-100"
                phx-click={JS.navigate(
                  if @role == "admin" do
                    ~p"/admin/kursus/#{kursus.id}"
                  else
                    ~p"/pekerja/kursus/#{kursus.id}"
                  end
                )}
              >
                <td class="px-4 py-3"><%= kursus.nama_kursus %></td>
                <td class="px-4 py-3"><%= kursus.tarikh_mula %></td>
                <td class="px-4 py-3"><%= kursus.tarikh_akhir %></td>
                <td class="px-4 py-3"><%= kursus.status_kursus %></td>
                <td class="px-4 py-3"><%= kursus.kaedah %></td>
                <td class="px-4 py-3"><%= kursus.anjuran %></td>
                <td class="px-4 py-3"><%= kursus.kuota %></td>

                <!-- Gambar Anjuran -->
                <td class="px-4 py-3">
                  <%= if kursus.gambar_anjuran do %>
                    <img src={kursus.gambar_anjuran} alt="Gambar Anjuran"
                        class="w-16 h-16 rounded-lg object-cover border" />
                  <% else %>
                    <span class="text-gray-400 text-xs">Tiada</span>
                  <% end %>
                </td>

                <!-- Gambar Kursus -->
                <td class="px-4 py-3">
                  <%= if kursus.gambar_kursus do %>
                    <img src={kursus.gambar_kursus} alt="Gambar Kursus"
                        class="w-16 h-16 rounded-lg object-cover border" />
                  <% else %>
                    <span class="text-gray-400 text-xs">Tiada</span>
                  <% end %>
                </td>

                <!-- Tindakan -->
                <td class="px-4 py-3 space-x-3" phx-click="noop">
                  <.link
                    patch={
                      if @role == "admin",
                        do: ~p"/admin/kursus/#{kursus.id}/edit",
                        else: ~p"/pekerja/kursus/#{kursus.id}/edit"
                    }
                    class="text-blue-600 font-medium hover:underline"
                  >
                    Edit
                  </.link>

                  <.link
                    phx-click="delete"
                    phx-value-id={kursus.id}
                    data-confirm="Are you sure?"
                    class="text-red-600 font-medium hover:underline"
                  >
                    Delete
                  </.link>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>


      <!-- ✅ Pagination -->
      <div class="flex justify-center items-center space-x-2 my-6">
        <%= if @page > 1 do %>
          <button phx-click="goto_page" phx-value-page={@page - 1}
                  class="px-3 py-1 rounded bg-gray-200 text-gray-800 hover:bg-gray-300">Prev</button>
        <% end %>

        <%= for p <- 1..@total_pages do %>
          <button phx-click="goto_page" phx-value-page={p}
                  class={"px-3 py-1 rounded " <>
                    if p == @page, do: "bg-blue-600 text-white", else: "bg-gray-200 text-gray-800 hover:bg-gray-300"}>
            <%= p %>
          </button>
        <% end %>

        <%= if @page < @total_pages do %>
          <button phx-click="goto_page" phx-value-page={@page + 1}
                  class="px-3 py-1 rounded bg-gray-200 text-gray-800 hover:bg-gray-300">Next</button>
        <% end %>
      </div>

      <!-- Modal for Add/Edit Kursus -->
      <div :if={@live_action in [:new, :edit]} class="fixed inset-0 z-50 overflow-y-auto">
        <!-- Background overlay with reduced opacity so table is still visible -->
        <div class="fixed inset-0 bg-black bg-opacity-30 transition-opacity" phx-click={
          if @role == "admin",
            do: JS.patch(@return_to || ~p"/admin/kursus"),
            else: JS.patch(@return_to || ~p"/pekerja/kursus")
        }></div>

        <!-- Modal content positioned to not cover the table -->
        <div class="flex min-h-full items-start justify-end p-4 pt-20">
          <div class="relative bg-white rounded-xl shadow-xl max-w-4xl w-full mx-auto transform transition-all">
            <!-- Modal header -->
            <div class="flex items-center justify-between p-6 border-b border-gray-200 bg-gradient-to-r from-blue-50 to-blue-100 rounded-t-xl">
              <h3 class="text-lg font-semibold text-blue-800 flex items-center gap-2">
                <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                </svg>
                <%= @page_title %>
              </h3>
              <button
                phx-click={
                  if @role == "admin",
                    do: JS.patch(@return_to || ~p"/admin/kursus"),
                    else: JS.patch(@return_to || ~p"/pekerja/kursus")
                }
                class="text-gray-400 hover:text-gray-600 transition-colors duration-200"
              >
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
              </button>
            </div>

            <!-- Modal body -->
            <div class="p-6">
              <.live_component
                module={SpkpProjectWeb.KursussLive.FormComponent}
                id={@kursuss.id || :new}
                title={@page_title}
                action={@live_action}
                kursuss={@kursuss}
                patch={
                  if @role == "admin",
                    do: @return_to || ~p"/admin/kursus",
                    else: @return_to || ~p"/pekerja/kursus"
                }
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  """
end

end

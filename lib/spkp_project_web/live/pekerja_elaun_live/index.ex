defmodule SpkpProjectWeb.PekerjaElaunLive.Index do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Elaun
  alias SpkpProject.Accounts

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    maklumat_pekerja = Accounts.get_maklumat_pekerja_by_user_id(current_user.id)

    result = Elaun.list_elaun_pekerja_by_pekerja_paginated(maklumat_pekerja.id, 1, 5)

    {:ok,
     socket
     |> assign(:elaun_saya, result.data)
     |> assign(:page, result.page)
     |> assign(:total_pages, result.total_pages)
     |> assign(:per_page, result.per_page)
     |> assign(:maklumat_pekerja_id, maklumat_pekerja.id)
     |> assign(:role, socket.assigns.current_user.role)}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    {:noreply, assign(socket, :current_path, URI.parse(uri).path)}
  end

  @impl true
  def handle_event("goto_page", %{"page" => page}, socket) do
    page = String.to_integer(page)

    result =
      Elaun.list_elaun_pekerja_by_pekerja_paginated(
        socket.assigns.maklumat_pekerja_id,
        page,
        socket.assigns.per_page
      )

    {:noreply,
     socket
     |> assign(:elaun_saya, result.data)
     |> assign(:page, result.page)
     |> assign(:total_pages, result.total_pages)}
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
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Status Permohonan</h1>
            <p class="text-gray-600">Status permohonan terkini anda</p>
          </div>
        </div>

        <!-- Table (styled like kursus kategori) -->
        <div class="px-10 w-full">
          <table class="w-full border border-gray-300 rounded-lg shadow-lg text-center">
            <thead>
              <tr class="bg-blue-900 text-white">
                <th class="px-4 py-3">Tarikh Mula</th>
                <th class="px-4 py-3">Tarikh Akhir</th>
                <th class="px-4 py-3">Status</th>
                <th class="px-4 py-3">Jumlah (RM)</th>
              </tr>
            </thead>

            <tbody>
              <%= for elaun <- @elaun_saya do %>
                <tr
                  class="border-b cursor-pointer transition duration-200 ease-in-out hover:scale-[1.01] hover:shadow-md hover:bg-gray-100"
                  phx-click={JS.navigate(~p"/pekerja/elaun/#{elaun.id}")}
                >
                  <td class="px-4 py-3"><%= elaun.tarikh_mula %></td>
                  <td class="px-4 py-3"><%= elaun.tarikh_akhir %></td>
                  <td class="px-4 py-3"><%= elaun.status_permohonan %></td>
                  <td class="px-4 py-3"><%= elaun.jumlah_keseluruhan %></td>
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>

        <!-- Pagination -->
        <div class="flex justify-center items-center space-x-2 mt-4">
          <button
            phx-click="goto_page"
            phx-value-page={@page - 1}
            disabled={@page <= 1}
            class="px-3 py-1 rounded border bg-white text-gray-700 disabled:opacity-50"
          >
            Prev
          </button>

          <%= for p <- 1..@total_pages do %>
            <button
              phx-click="goto_page"
              phx-value-page={p}
              class={
                "px-3 py-1 rounded border " <>
                if p == @page, do: "bg-blue-600 text-white", else: "bg-white text-gray-700"
              }
            >
              <%= p %>
            </button>
          <% end %>

          <button
            phx-click="goto_page"
            phx-value-page={@page + 1}
            disabled={@page >= @total_pages}
            class="px-3 py-1 rounded border bg-white text-gray-700 disabled:opacity-50"
          >
            Next
          </button>
        </div>
      </div>
    </div>
    """
  end
end

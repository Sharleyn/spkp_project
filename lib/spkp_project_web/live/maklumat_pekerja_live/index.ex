defmodule SpkpProjectWeb.MaklumatPekerjaLive.Index do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Accounts
  alias SpkpProject.Accounts.MaklumatPekerja

  @impl true
  def mount(_params, _session, socket) do
    result = Accounts.list_maklumat_pekerja_paginated(1, 10)

    {:ok,
     socket
     |> assign(:maklumat_pekerja_collection, result.data)
     |> assign(:page, result.page)
     |> assign(:total_pages, result.total_pages)
     |> assign(:per_page, result.per_page)}
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
    {:noreply, assign(socket, :maklumat_pekerja_collection, [maklumat_pekerja | socket.assigns.maklumat_pekerja_collection])}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    maklumat_pekerja = Accounts.get_maklumat_pekerja!(id)
    {:ok, _} = Accounts.delete_maklumat_pekerja(maklumat_pekerja)

    {:noreply, assign(socket, :maklumat_pekerja_collection, Enum.reject(socket.assigns.maklumat_pekerja_collection, fn i -> i.id == maklumat_pekerja.id end))}
  end

  @impl true
  def handle_event("goto_page", %{"page" => page}, socket) do
    page = String.to_integer(page)
    result = Accounts.list_maklumat_pekerja_paginated(page, socket.assigns.per_page)

    {:noreply,
     socket
     |> assign(:maklumat_pekerja_collection, result.data)
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
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Senarai Pekerja</h1>
            <p class="text-gray-600">Semak dan urus maklumat pekerja</p>
          </div>
        </div>

        <!-- Table -->
        <.table
          id="maklumat_pekerja"
          rows={@maklumat_pekerja_collection}
          row_click={fn maklumat -> JS.navigate(~p"/admin/maklumat_pekerja/#{maklumat.id}") end}
        >
          <:col :let={m} label="Nama Penuh"><%= m.user.full_name %></:col>
          <:col :let={m} label="Emel"><%= m.user.email %></:col>
          <:col :let={m} label="No ic"><%= m.no_ic %></:col>
          <:col :let={m} label="No tel"><%= m.no_tel %></:col>
          <:col :let={m} label="Nama bank"><%= m.nama_bank %></:col>
          <:col :let={m} label="No akaun"><%= m.no_akaun %></:col>
        </.table>

        <!-- Pagination -->
        <div class="flex justify-center mt-4 space-x-2">
          <!-- Prev -->
          <%= if @page > 1 do %>
            <button phx-click="goto_page" phx-value-page={@page - 1} class="px-3 py-1 rounded border bg-white text-gray-700 hover:bg-gray-100">
              Prev
            </button>
          <% end %>

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

          <!-- Next -->
          <%= if @page < @total_pages do %>
            <button phx-click="goto_page" phx-value-page={@page + 1} class="px-3 py-1 rounded border bg-white text-gray-700 hover:bg-gray-100">
              Next
            </button>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end

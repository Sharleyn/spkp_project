defmodule SpkpProjectWeb.KursusKategoriLive.Index do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Kursus
  alias SpkpProject.Kursus.KursusKategori

  @impl true
  def mount(_params, _session, socket) do
    role = socket.assigns.current_user.role

    {:ok,
     socket
     |> assign(:role, role)
     |> assign(:page, 1)       # default page
     |> assign(:per_page, 5)   # default items
     |> load_kursus_kategori()}
  end

  # Load data dengan pagination
  defp load_kursus_kategori(socket) do
    data = Kursus.list_kursus_kategori_paginated(socket.assigns.page, socket.assigns.per_page)

    socket
    |> assign(:pagination, data)
    |> assign(:kursus_kategori_collection, data.entries)
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
    |> assign(:page_title, "Edit Kursus kategori")
    |> assign(:kursus_kategori, Kursus.get_kursus_kategori!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Kursus kategori")
    |> assign(:kursus_kategori, %KursusKategori{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Kursus kategori")
    |> assign(:kursus_kategori, nil)
  end

  @impl true
  def handle_info(
        {SpkpProjectWeb.KursusKategoriLive.FormComponent, {:saved, _kursus_kategori}},
        socket
      ) do
    # reload table selepas tambah/edit
    {:noreply, load_kursus_kategori(socket)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    kursus_kategori = Kursus.get_kursus_kategori!(id)
    {:ok, _} = Kursus.delete_kursus_kategori(kursus_kategori)

    # reload table selepas delete
    {:noreply, load_kursus_kategori(socket)}
  end

  # event dummy untuk hentikan row click
  @impl true
  def handle_event("noop", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("paginate", %{"page" => page}, socket) do
    {:noreply,
     socket
     |> assign(:page, String.to_integer(page))
     |> load_kursus_kategori()}
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
            </div>
          </div>
        </.header>

        <!-- Page Header -->
        <div class="flex items-center justify-between mb-8 px-10 py-6">
          <div>
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Kategori Kursus</h1>
            <p class="text-gray-600">Urus kursus mengikut kategori</p>
          </div>

          <.link patch={
            if @role == "admin",
              do: ~p"/admin/kursus_kategori/new",
              else: ~p"/pekerja/kursus_kategori/new"
          }>
            <.button class="bg-blue-900 hover:bg-blue-700 text-white px-4 py-2 rounded-lg shadow">
              Kategori Kursus Baru
            </.button>
          </.link>
        </div>

        <!-- ✅ Table -->
        <div class="px-10 w-full">
          <table class="w-full border border-gray-300 rounded-lg shadow-lg text-center">
            <thead>
              <tr class="bg-blue-900 text-white">
                <th class="px-4 py-3">Kategori Kursus</th>
                <th class="px-4 py-3">Tindakan</th>
              </tr>
            </thead>

            <tbody>
              <%= for kursus_kategori <- @kursus_kategori_collection do %>
                <tr
                  class="border-b cursor-pointer transition duration-200 ease-in-out hover:scale-[1.01] hover:shadow-md hover:bg-gray-100"
                  phx-click={JS.navigate(
                    if @role == "admin" do
                      ~p"/admin/kursus_kategori/#{kursus_kategori.id}"
                    else
                      ~p"/pekerja/kursus_kategori/#{kursus_kategori.id}"
                    end
                  )}
                >
                  <!-- Kategori -->
                  <td class="px-4 py-3">
                    <%= kursus_kategori.kategori %>
                  </td>

                  <!-- Tindakan -->
                  <td
                    class="px-4 py-3 space-x-3"
                    phx-click="noop"
                  >
                    <!-- Edit -->
                    <.link
                      patch={
                        if @role == "admin" do
                          ~p"/admin/kursus_kategori/#{kursus_kategori.id}/edit"
                        else
                          ~p"/pekerja/kursus_kategori/#{kursus_kategori.id}/edit"
                        end
                      }
                      class="text-blue-600 font-medium hover:underline"
                    >
                      Edit
                    </.link>

                    <!-- Delete -->
                    <.link
                      phx-click="delete"
                      phx-value-id={kursus_kategori.id}
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
          <!-- Prev button -->
          <%= if @pagination.page > 1 do %>
            <button
              phx-click="paginate"
              phx-value-page={@pagination.page - 1}
              class="px-3 py-1 rounded bg-gray-200 text-gray-800 hover:bg-gray-300"
            >
              Prev
            </button>
          <% end %>

          <!-- Page numbers -->
          <%= for p <- 1..@pagination.total_pages do %>
            <button
              phx-click="paginate"
              phx-value-page={p}
              class={
                "px-3 py-1 rounded " <>
                if p == @pagination.page, do: "bg-blue-600 text-white", else: "bg-gray-200 text-gray-800 hover:bg-gray-300"
              }
            >
              <%= p %>
            </button>
          <% end %>

          <!-- Next button -->
          <%= if @pagination.page < @pagination.total_pages do %>
            <button
              phx-click="paginate"
              phx-value-page={@pagination.page + 1}
              class="px-3 py-1 rounded bg-gray-200 text-gray-800 hover:bg-gray-300"
            >
              Next
            </button>
          <% end %>
        </div>

        <!-- Modal -->
        <.modal
          :if={@live_action in [:new, :edit]}
          id="kursus_kategori-modal"
          show
          on_cancel={
            if @role == "admin",
              do: JS.patch(~p"/admin/kursus_kategori"),
              else: JS.patch(~p"/pekerja/kursus_kategori")
          }
        >
          <.live_component
            module={SpkpProjectWeb.KursusKategoriLive.FormComponent}
            id={@kursus_kategori.id || :new}
            title={@page_title}
            action={@live_action}
            kursus_kategori={@kursus_kategori}
            patch={
              if @role == "admin",
                do: ~p"/admin/kursus_kategori",
                else: ~p"/pekerja/kursus_kategori"
            }
            role={@role}
          />
        </.modal>
      </div>
    </div>
    """
  end
end

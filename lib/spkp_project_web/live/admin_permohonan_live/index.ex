defmodule SpkpProjectWeb.PermohonanLive.Index do
  use SpkpProjectWeb, :live_view
  import Ecto.Query, warn: false

  alias SpkpProject.Userpermohonan.Userpermohonan
  alias SpkpProject.Repo

  @impl true
  def mount(_params, _session, socket) do
    role = socket.assigns.current_user.role

    {:ok,
     socket
     |> assign(:role, role)
     |> assign(:page, 1)       # default page
     |> assign(:per_page, 5)  # bilangan rekod setiap page
     |> load_permohonan()}
  end

  defp load_permohonan(socket) do
    page = socket.assigns.page
    per_page = socket.assigns.per_page

    query =
      from p in Userpermohonan,
        order_by: [desc: p.inserted_at],
        preload: [:user, :kursus]

    total_entries = Repo.aggregate(query, :count, :id)

    entries =
      query
      |> limit(^per_page)
      |> offset(^((page - 1) * per_page))
      |> Repo.all()

    total_pages = div(total_entries + per_page - 1, per_page)

    socket
    |> assign(:permohonan, entries)
    |> assign(:pagination, %{
      page: page,
      per_page: per_page,
      total_entries: total_entries,
      total_pages: total_pages
    })
    |> assign(:current_path, "/#{socket.assigns.role}/permohonan")
  end

  # helper route ikut role
  defp permohonan_show_path("admin", id), do: ~p"/admin/permohonan/#{id}"
  defp permohonan_show_path("pekerja", id), do: ~p"/pekerja/permohonan/#{id}"

  defp dashboard_path("admin"), do: ~p"/admin/dashboard"
  defp dashboard_path("pekerja"), do: ~p"/pekerja/dashboard"

  @impl true
  def handle_event("paginate", %{"page" => page}, socket) do
    {:noreply,
     socket
     |> assign(:page, String.to_integer(page))
     |> load_permohonan()}
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
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Senarai Permohonan</h1>
            <p class="text-gray-600">Semak dan urus permohonan</p>
          </div>
        </div>

        <!-- Wrapper table -->
        <div class="px-10 w-full">
          <table class="w-full border border-gray-300 rounded-lg shadow-lg text-center">
            <thead>
              <tr class="bg-blue-900 text-white">
                <th class="px-4 py-3">Nama Pemohon</th>
                <th class="px-4 py-3">Email</th>
                <th class="px-4 py-3">Kursus Dipohon</th>
                <th class="px-4 py-3">Tarikh Permohonan</th>
                <th class="px-4 py-3">Status</th>
                <th class="px-4 py-3">Tindakan</th>
              </tr>
            </thead>

          <tbody>
            <%= for p <- @permohonan do %>
              <tr
                class="border-b cursor-pointer transition duration-200 ease-in-out hover:scale-[1.01] hover:shadow-md hover:bg-gray-100"
                phx-click={JS.navigate(permohonan_show_path(@role, p.id))}
              >
                <td class="px-4 py-3"><%= p.user && p.user.full_name %></td>
                <td class="px-4 py-3"><%= p.user && p.user.email %></td>
                <td class="px-4 py-3"><%= p.kursus && p.kursus.nama_kursus %></td>
                <td class="px-4 py-3"><%= Calendar.strftime(p.inserted_at, "%d-%m-%Y") %></td>
                <td class="px-4 py-3">
                  <span class={
                    case p.status do
                      "Diterima" -> "px-2 py-1 text-xs rounded bg-green-100 text-green-800"
                      "Ditolak" -> "px-2 py-1 text-xs rounded bg-red-100 text-red-800"
                      _ -> "px-2 py-1 text-xs rounded bg-yellow-100 text-yellow-800"
                    end
                  }>
                    <%= p.status %>
                  </span>
                </td>
                <td class="px-4 py-3 space-x-2" phx-click="noop">
                  <.link
                    navigate={permohonan_show_path(@role, p.id)}
                    class="text-blue-600 font-medium hover:underline"
                  >
                    Lihat
                  </.link>
                </td>
              </tr>
            <% end %>
          </tbody>
          </table>

          <!-- ✅ Pagination -->
          <div class="flex justify-center items-center space-x-2 my-6">
            <!-- Prev -->
            <%= if @pagination.page > 1 do %>
              <button
                phx-click="paginate"
                phx-value-page={@pagination.page - 1}
                class="px-3 py-1 rounded bg-gray-200 text-gray-800 hover:bg-gray-300"
              >
                Prev
              </button>
            <% end %>

            <!-- Nombor pages -->
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

            <!-- Next -->
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

          <!-- butang kembali bawah table -->
          <div class="mt-4">
            <.link navigate={dashboard_path(@role)} class="bg-gray-600 text-white px-4 py-2 rounded">
              ← Kembali
            </.link>
          </div>
        </div>
      </div>
    </div>
    """
  end
end

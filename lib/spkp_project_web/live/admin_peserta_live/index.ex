defmodule SpkpProjectWeb.AdminPesertaLive.Index do
  use SpkpProjectWeb, :live_view
  alias SpkpProject.Repo
  alias SpkpProject.Kursus.KursusKategori

  @impl true
  def mount(_params, _session, socket) do
    role = socket.assigns.current_user.role

    participants_stats = %{
      total_participants: 50,
      active_participants: 50,
      completed_courses: 50
    }

    {:ok,
     socket
     |> assign(:role, role)
     |> assign(:participants_stats, participants_stats)
     |> assign(:page, 1)
     |> assign(:per_page, 5) # 5 per page
     |> assign(:current_path, socket.assigns[:uri] && URI.parse(socket.assigns.uri).path || "/")
     |> load_course_categories()}
  end

  # Semua handle_event/3 diletakkan bersama supaya compiler tidak komplen
  @impl true
  def handle_event("noop", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("goto_page", %{"page" => page}, socket) do
    # ensure page param is integer (comes as string from phx-value)
    page_int =
      case page do
        p when is_integer(p) -> p
        p when is_binary(p) ->
          case Integer.parse(p) do
            {n, ""} -> n
            _ -> socket.assigns.page
          end
        _ -> socket.assigns.page
      end

    {:noreply,
     socket
     |> assign(:page, page_int)
     |> load_course_categories()}
  end

  # helper untuk bina route ikut role
  defp kategori_path("admin", id), do: ~p"/admin/kategori/#{id}"
  defp kategori_path("pekerja", id), do: ~p"/pekerja/kategori/#{id}"

  # Load data dengan pagination (per_page set di assigns)
  defp load_course_categories(socket) do
    all_categories =
      KursusKategori
      |> Repo.all()
      |> Repo.preload(:kursus)
      |> Enum.map(fn kategori ->
        %{
          id: kategori.id,
          name: kategori.kategori,
          course_count: length(kategori.kursus)
        }
      end)

    total_count = length(all_categories)
    per_page = socket.assigns.per_page
    # ceil division: (total_count + per_page - 1) // per_page
    total_pages = max(div(total_count + per_page - 1, per_page), 1)

    page =
      socket.assigns.page
      |> min(total_pages)
      |> max(1)

    start_index = (page - 1) * per_page
    # Enum.slice(list, start_index, count) returns [] if out of range
    page_entries = Enum.slice(all_categories, start_index, per_page)

    socket
    |> assign(:course_categories_collection, page_entries)
    |> assign(:total_pages, total_pages)
    |> assign(:total_count, total_count)
    |> assign(:page, page)
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
            </div>
          </div>
        </.header>

        <!-- Page Content -->
        <div class="flex-1 p-6">
          <!-- Page Title and Description -->
          <div class="mb-6">
          <h1 class="text-4xl font-bold text-gray-900 mb-2">Peserta</h1>
            <p class="text-sm text-gray-600 mb-2">Pantau dan urus semua peserta kursus</p>
            <div class="w-full h-px bg-gray-300"></div>
          </div>

          <!-- Course Categories Table -->
          <div class="bg-white rounded-lg shadow-sm border border-gray-200">
            <div class="bg-gray-100 px-6 py-4 border-b border-gray-200">
              <h2 class="text-lg font-bold text-gray-900">Senarai Semua Kategori Kursus</h2>
            </div>

            <div class="overflow-x-auto">
              <table class="w-full border border-gray-300 rounded-lg shadow-lg text-center">
                <thead>
                  <tr class="bg-blue-900 text-white">
                    <th class="px-4 py-3">Bil.</th>
                    <th class="px-4 py-3">Kategori Kursus</th>
                    <th class="px-4 py-3">Jumlah Kursus</th>
                    <th class="px-4 py-3">Tindakan</th>
                  </tr>
                </thead>
                <tbody>
                  <%= for {category, index} <- Enum.with_index(@course_categories_collection, 1 + (@page - 1) * @per_page) do %>
                    <tr
                      class="border-b cursor-pointer transition duration-200 ease-in-out hover:scale-[1.01] hover:shadow-md hover:bg-gray-100"
                      phx-click={JS.navigate(kategori_path(@role, category.id))}
                    >
                      <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900"><%= index %></td>
                      <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900"><%= category.name %></td>
                      <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900"><%= category.course_count %></td>
                      <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" phx-click="noop">
                        <.link navigate={kategori_path(@role, category.id)} class="text-blue-600 hover:text-blue-800 font-medium">
                          Lihat
                        </.link>
                      </td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Pagination -->
          <div class="flex justify-center mt-6 space-x-2">
            <button
              phx-click="goto_page"
              phx-value-page={@page - 1}
              class="px-3 py-1 rounded border bg-white text-gray-700 disabled:opacity-50"
              disabled={@page <= 1}
            >
              Prev
            </button>

            <%= for p <- 1..@total_pages do %>
              <button
                phx-click="goto_page"
                phx-value-page={p}
                class={ "px-3 py-1 rounded border " <> if(p == @page, do: "bg-blue-600 text-white", else: "bg-white text-gray-700") }
              >
                <%= p %>
              </button>
            <% end %>

            <button
              phx-click="goto_page"
              phx-value-page={@page + 1}
              class="px-3 py-1 rounded border bg-white text-gray-700 disabled:opacity-50"
              disabled={@page >= @total_pages}
            >
              Next
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end
end

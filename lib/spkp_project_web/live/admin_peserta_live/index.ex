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

    # Ambil data sebenar dari DB
    course_categories =
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

    {:ok,
     socket
     |> assign(:role, role)
     |> assign(:participants_stats, participants_stats)
     |> assign(:course_categories, course_categories)
     |> assign(:current_path, socket.assigns[:uri] && URI.parse(socket.assigns.uri).path || "/")}
  end

  # helper untuk bina route ikut role
  defp kategori_path("admin", id), do: ~p"/admin/kategori/#{id}"
  defp kategori_path("pekerja", id), do: ~p"/pekerja/kategori/#{id}"

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

        <!-- Page Content -->
        <div class="flex-1 p-6">
          <!-- Page Title and Description -->
          <div class="mb-6">
            <p class="text-sm text-gray-600 mb-2">Pantau dan urus semua peserta kursus</p>
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Peserta</h1>
            <div class="w-full h-px bg-gray-300"></div>
          </div>

          <!-- Add Participant Button -->
          <div class="flex justify-end mb-6">
            <button class="bg-gray-200 hover:bg-gray-300 text-gray-800 px-4 py-2 rounded-lg border border-gray-300 transition-colors">
              + Tambah peserta
            </button>
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
                  <%= for {category, index} <- Enum.with_index(@course_categories, 1) do %>
                    <tr class="border-b hover:bg-gray-100">
                      <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900"><%= index %></td>
                      <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900"><%= category.name %></td>
                      <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900"><%= category.course_count %></td>
                      <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900">
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
        </div>
      </div>
    </div>
    """
  end
end

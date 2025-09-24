defmodule SpkpProjectWeb.PermohonanLive.Index do
  use SpkpProjectWeb, :live_view
  alias SpkpProject.Userpermohonan.Userpermohonan
  alias SpkpProject.Repo

  @impl true
  def mount(_params, _session, socket) do
    permohonan =
      Userpermohonan
      |> Repo.all()
      |> Repo.preload([:user, :kursus])

    {:ok,
     socket
     |> assign(:permohonan, permohonan)
     |> assign(:current_path, "/admin/permohonan")}
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

      <!-- Wrapper table -->
      <div class="px-10 w-full">
        <table class="w-full bg-white border rounded-lg">
        <thead>
          <tr class="bg-gray-100">
            <th class="px-4 py-2">Nama Pemohon</th>
            <th class="px-4 py-2">Email</th>
            <th class="px-4 py-2">Kursus Dipohon</th>
            <th class="px-4 py-2">Tarikh Permohonan</th>
            <th class="px-4 py-2">Status</th>
            <th class="px-4 py-2">Tindakan</th>
          </tr>
        </thead>

        <tbody>
          <%= for p <- @permohonan do %>
            <tr class="border-t cursor-pointer hover:bg-gray-100"
                phx-click={JS.navigate(~p"/admin/permohonan/#{p.id}")}>

                      <!-- ✅ Column debug -->
              <td class="px-4 py-2"><%= inspect(p.id) %></td>

              <td class="px-4 py-2"><%= p.user && p.user.full_name %></td>
              <td class="px-4 py-2"><%= p.user && p.user.email %></td>
              <td class="px-4 py-2"><%= p.kursus && p.kursus.nama_kursus %></td>
              <td class="px-4 py-2"><%= Calendar.strftime(p.inserted_at, "%d-%m-%Y") %></td>
              <td class="px-4 py-2">
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

              <td class="px-4 py-2 space-x-2">
                <.link navigate={~p"/admin/permohonan/#{p.id}"} class="bg-gray-600 text-white px-2 py-1 rounded">
                  Lihat
                </.link>
                <button phx-click="edit" phx-value-id={p.id} class="bg-blue-600 text-white px-2 py-1 rounded">Edit</button>
                <button phx-click="delete" phx-value-id={p.id} class="bg-red-600 text-white px-2 py-1 rounded">Delete</button>
              </td>
            </tr>
          <% end %>
        </tbody>

      </table>

      <!-- butang kembali bawah table -->
      <div class="mt-4">
        <.link navigate={~p"/admin/dashboard"} class="bg-gray-600 text-white px-4 py-2 rounded">
          ← Kembali
        </.link>
      </div>

    </div>
    </div>
    </div>
    """
  end
end

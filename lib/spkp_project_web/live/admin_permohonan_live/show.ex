defmodule SpkpProjectWeb.PermohonanLive.Show do
  use SpkpProjectWeb, :live_view
  alias SpkpProject.Userpermohonan.Userpermohonan
  alias SpkpProject.Repo

  @impl true
  def mount(_params, _session, socket) do
    role = socket.assigns.current_user.role
    {:ok, assign(socket, :role, role)}
  end

  @impl true
  def handle_params(%{"id" => id}, uri, socket) do
    permohonan =
      Userpermohonan
      |> Repo.get!(id)
      |> Repo.preload([:kursus, user: :user_profile])

    current_path =
      uri
      |> URI.parse()
      |> Map.get(:path)

    {:noreply,
     socket
     |> assign(:permohonan, permohonan)
     |> assign(:current_path, current_path)
     |> assign(:page_title, page_title(socket.assigns.live_action))}
  end

  defp page_title(:show), do: "Maklumat Permohonan"
  defp page_title(:edit), do: "Edit Permohonan"

  # helper untuk path kembali ikut role
  defp back_path("admin"), do: ~p"/admin/permohonan"
  defp back_path("pekerja"), do: ~p"/pekerja/permohonan"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full min-h-screen bg-gray-100 flex">
      <!-- Sidebar -->
      <.live_component
        module={SpkpProjectWeb.SidebarComponent}
        id="sidebar"
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
          <div class="mb-6">
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Maklumat Permohonan</h1>
            <p class="text-sm text-gray-600 mb-2">Lihat maklumat permohonan kursus</p>
          </div>

          <div class="bg-white shadow rounded-lg p-6 space-y-4">
            <p><strong>Nama Pemohon:</strong> <%= @permohonan.user.full_name %></p>
            <p><strong>Email:</strong> <%= @permohonan.user.email %></p>
            <p><strong>Kursus Dipohon:</strong> <%= @permohonan.kursus.nama_kursus %></p>
            <p><strong>Tarikh Permohonan:</strong> <%= Calendar.strftime(@permohonan.inserted_at, "%d-%m-%Y") %></p>
            <p><strong>Status:</strong> <%= @permohonan.status %></p>

            <%= if profile = @permohonan.user.user_profile do %>
              <hr class="my-4"/>
              <h2 class="text-xl font-semibold">Maklumat Profil Pengguna</h2>
              <p><strong>No. IC:</strong> <%= profile.ic %></p>
              <p><strong>Umur:</strong> <%= profile.age %></p>
              <p><strong>Jantina:</strong> <%= profile.gender %></p>
              <p><strong>No. Telefon:</strong> <%= profile.phone_number %></p>
              <p><strong>Alamat:</strong> <%= profile.address %></p>
              <p><strong>Daerah:</strong> <%= profile.district %></p>
              <p><strong>Pendidikan:</strong> <%= profile.education %></p>

              <%= if profile.ic_attachment do %>
                <p><strong>Lampiran IC:</strong></p>
                <div class="border rounded-lg overflow-hidden h-96">
                  <iframe src={profile.ic_attachment} type="application/pdf" class="w-full h-full">
                    Dokumen tidak dapat dipaparkan.
                    <a href={profile.ic_attachment} target="_blank">Muat Turun</a>
                  </iframe>
                </div>
              <% end %>
            <% end %>

            <%= if @permohonan.kursus && @permohonan.kursus.nota_kursus do %>
              <p><strong>Nota Kursus:</strong></p>
              <div class="border rounded-lg overflow-hidden h-96">
                <iframe src={@permohonan.kursus.nota_kursus} type="application/pdf" class="w-full h-full">
                  PDF tidak dapat dipaparkan.
                  <a href={@permohonan.kursus.nota_kursus} target="_blank">Muat Turun</a>
                </iframe>
              </div>
            <% end %>

            <%= if @permohonan.kursus && @permohonan.kursus.jadual_kursus do %>
              <p><strong>Jadual Kursus:</strong></p>
              <div class="border rounded-lg overflow-hidden h-96">
                <iframe src={@permohonan.kursus.jadual_kursus} type="application/pdf" class="w-full h-full">
                  PDF tidak dapat dipaparkan.
                  <a href={@permohonan.kursus.jadual_kursus} target="_blank">Muat Turun</a>
                </iframe>
              </div>
            <% end %>

            <!-- Buttons -->
            <div class="mt-6 space-x-2">
              <.link navigate={back_path(@role)} class="bg-gray-600 text-white px-4 py-2 rounded">
                ← Kembali
              </.link>

              <!-- Hanya admin boleh edit/padam -->
              <%= if @role == "admin" do %>
                <.link patch={~p"/admin/permohonan/#{@permohonan.id}/show/edit"} class="bg-blue-600 text-white px-4 py-2 rounded">
                  Edit
                </.link>
                <button
                  phx-click="delete"
                  phx-value-id={@permohonan.id}
                  class="bg-red-600 text-white px-4 py-2 rounded"
                  data-confirm="Adakah anda pasti mahu padam permohonan ini?">
                  Delete
                </button>
              <% end %>
            </div>
          </div>
        </div>

        <!-- Modal untuk edit -->
        <%= if @live_action == :edit and @role == "admin" do %>
          <.modal
            id="permohonan-modal"
            show
            on_cancel={JS.patch(~p"/admin/permohonan/#{@permohonan.id}")}>
            <.live_component
              module={SpkpProjectWeb.PermohonanLive.FormComponent}
              id="permohonan-form"
              permohonan={@permohonan}
              action={@live_action}
              title="Edit Permohonan"
              patch={~p"/admin/permohonan/#{@permohonan.id}"}
            />
          </.modal>
        <% end %>
      </div>
    </div>
    """
  end
end

defmodule SpkpProjectWeb.AssignStaffLive do
  use SpkpProjectWeb, :live_view
  alias SpkpProject.Accounts

  @impl true
  def mount(_params, _session, socket) do
    users = Accounts.list_users()
    role = socket.assigns.current_user.role

    {:ok,
     assign(socket,
       users: users,
       user: nil,
       changeset: nil,
       live_action: :index,
       role: role,
       current_path: socket.host_uri.path
     )}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user_role(user)

    {:noreply,
     assign(socket,
       user: user,
       changeset: changeset,
       live_action: socket.assigns.live_action || :edit
     )}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, assign(socket, live_action: :index)}
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

    <!-- Main Content -->
    <main class="flex-1 p-6">
      <%= if @live_action == :edit do %>
        <h1 class="text-2xl font-bold mb-4">Tukar Role Pengguna</h1>

        <.simple_form for={@changeset} as={:user} phx-submit="save" :let={f}>
          <.input
            field={f[:role]}
            type="select"
            label="Role"
            options={[{"User", "user"}, {"Pekerja", "pekerja"}, {"Admin", "admin"}]}
          />
          <:actions>
            <.button>Simpan</.button>
            <.link patch={~p"/admin/assignstaff"} class="ml-2 text-gray-600 hover:underline">
              Kembali
            </.link>
          </:actions>
        </.simple_form>
      <% else %>
        <h1 class="text-2xl font-bold mb-4">Senarai Pengguna</h1>

        <table class="min-w-full border border-gray-300">
          <thead class="bg-gray-100">
            <tr>
              <th class="px-4 py-2">Nama</th>
              <th class="px-4 py-2">Email</th>
              <th class="px-4 py-2">Role</th>
              <th class="px-4 py-2">Tindakan</th>
            </tr>
          </thead>
          <tbody>
            <%= for user <- @users do %>
              <tr>
                <td class="border px-4 py-2"><%= user.full_name %></td>
                <td class="border px-4 py-2"><%= user.email %></td>
                <td class="border px-4 py-2">
                  <span class={
                    case user.role do
                      "admin" -> "text-red-600 font-bold"
                      "pekerja" -> "text-green-600"
                      _ -> "text-gray-700"
                    end
                  }>
                    <%= user.role %>
                  </span>
                </td>
                <td class="border px-4 py-2">
                  <.link patch={~p"/admin/assignstaff/#{user.id}/edit"} class="text-blue-600 hover:underline">
                    Tukar Role
                  </.link>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      <% end %>
    </main>
  </div>
  </div>
  """
end


  @impl true
  def handle_event("save", %{"user" => %{"role" => role}}, socket) do
    case Accounts.update_user_role(socket.assigns.user, role) do
      {:ok, _user} ->
        users = Accounts.list_users()

        {:noreply,
         socket
         |> put_flash(:info, "Role berjaya dikemaskini")
         |> assign(users: users, user: nil, changeset: nil, live_action: :index)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

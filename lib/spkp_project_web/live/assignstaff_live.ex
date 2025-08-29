defmodule SpkpProjectWeb.AssignStaffLive do
  use SpkpProjectWeb, :live_view
  alias SpkpProject.Accounts

  @impl true
  def mount(_params, _session, socket) do
    users = Accounts.list_users()
    {:ok, assign(socket, users: users, user: nil, changeset: nil, live_action: :index)}
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
  def render(%{live_action: :edit} = assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-2xl font-bold mb-4">Tukar Role Pengguna</h1>

      <.simple_form
        for={@changeset}
        as={:user}
        phx-submit="save"
        :let={f}>
      >
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
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="p-6">
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

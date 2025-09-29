defmodule SpkpProjectWeb.TukarKataLaluanLive do
  use SpkpProjectWeb, :live_view
  alias SpkpProject.Accounts

  @impl true
  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_password(socket.assigns.current_user)

    {:ok,
     socket
     |> assign(:role, socket.assigns.current_user.role)
     |> assign(:current_path, "/tukarkatalaluan")
     |> assign(:form, to_form(changeset))}
  end


  @impl true
  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      socket.assigns.current_user
      |> Accounts.change_user_password(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  @impl true
  def handle_event("save", %{"user" => %{"current_password" => current_password} = user_params}, socket) do
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, current_password, user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Kata laluan berjaya ditukar. Sila log masuk semula.")
         |> redirect(to: ~p"/users/log_in")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
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

        <!-- Main Content Area -->
        <div class="flex-1 bg-gray-100 p-6">
          <div class="bg-white rounded-lg shadow-sm border p-8 max-w-2xl mx-auto">
            <h3 class="text-3xl font-semibold text-gray-800 text-center mb-8">Tukar Kata Laluan</h3>

            <.simple_form
              for={@form}
              id="password-form"
              phx-submit="save"
              phx-change="validate"
            >
              <.input
                field={@form[:current_password]}
                type="password"
                label="Kata Laluan Lama"
                required
              />
              <.input
                field={@form[:password]}
                type="password"
                label="Kata Laluan Baru"
                required
              />
              <.input
                field={@form[:password_confirmation]}
                type="password"
                label="Sahkan Kata Laluan Baru"
                required
              />
              <:actions>
                <.button phx-disable-with="Menyimpan...">Simpan</.button>
              </:actions>
            </.simple_form>

          </div>
        </div>
      </div>
    </div>
    """
  end
end

defmodule SpkpProjectWeb.MaklumatSayaLive do
  use SpkpProjectWeb, :live_view
  alias SpkpProject.Accounts
  alias SpkpProject.Accounts.MaklumatPekerja

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    maklumat =
      Accounts.get_maklumat_pekerja_by_user_id(current_user.id) ||
        %MaklumatPekerja{user_id: current_user.id, user: current_user}

    {:ok,
     socket
     |> assign(:maklumat_pekerja, maklumat)
     |> assign(:changeset, Accounts.change_maklumat_pekerja(maklumat))
     |> assign(:current_path, "")
     |> assign(:role, socket.assigns.current_user.role)}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    {:noreply, assign(socket, :current_path, URI.parse(uri).path)}
  end

  @impl true
  def handle_event("validate", %{"maklumat_pekerja" => params}, socket) do
    changeset =
      socket.assigns.maklumat_pekerja
      |> Accounts.change_maklumat_pekerja(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"maklumat_pekerja" => params}, socket) do
    case socket.assigns.maklumat_pekerja.id do
      nil ->
        case Accounts.create_maklumat_pekerja(
               Map.put(params, "user_id", socket.assigns.current_user.id)
             ) do
          {:ok, maklumat} ->
            {:noreply,
             socket
             |> put_flash(:info, "Maklumat pekerja berjaya disimpan")
             |> assign(:maklumat_pekerja, maklumat)
             |> assign(:changeset, Accounts.change_maklumat_pekerja(maklumat))}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end

      _id ->
        case Accounts.update_maklumat_pekerja(socket.assigns.maklumat_pekerja, params) do
          {:ok, maklumat} ->
            {:noreply,
             socket
             |> put_flash(:info, "Maklumat pekerja berjaya dikemaskini")
             |> assign(:maklumat_pekerja, maklumat)
             |> assign(:changeset, Accounts.change_maklumat_pekerja(maklumat))}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end
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
              <h1 class="text-xl font-semibold text-gray-800"><%= if @role == "admin", do: "SPKP Admin Dashboard", else: "SPKP Pekerja Dashboard" %></h1>
            </div>

            <div class="flex items-center space-x-4">
              <span class="text-gray-600"><%= @current_user.full_name %></span>
              <.link href={~p"/users/log_out"} method="delete" class="text-gray-600 hover:text-gray-800">
                Logout
              </.link>
              <div class="w-8 h-8 bg-gray-300 rounded-full"></div>
            </div>
          </div>
        </.header>

        <!-- Page Header -->
        <div class="flex items-center justify-between mb-6 px-10 py-6">
          <div>
            <h1 class="text-3xl font-bold text-gray-900">Maklumat Saya</h1>
            <p class="text-gray-600">Isi maklumat peribadi anda dengan lengkap</p>
          </div>
        </div>

        <!-- Form -->
        <div class="bg-white rounded-lg shadow-md p-8 mx-10">
          <.simple_form
            for={@changeset}
            as={:maklumat_pekerja}
            id="maklumat-form"
            phx-submit="save"
            phx-change="validate"
            :let={f}
          >
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <!-- Nama & Email (readonly) -->
              <.input
                name="user_name"
                value={@maklumat_pekerja.user.full_name}
                label="Nama Penuh"
                readonly
                class="md:col-span-2"
              />

              <.input
                name="user_email"
                value={@maklumat_pekerja.user.email}
                label="Email"
                readonly
                class="md:col-span-2"
              />

              <!-- Input Maklumat -->
              <.input field={f[:no_ic]} type="text" label="Nombor IC" />
              <.input field={f[:no_tel]} type="text" label="Nombor Telefon" />
              <.input field={f[:nama_bank]} type="text" label="Nama Bank" />
              <.input field={f[:no_akaun]} type="text" label="Nombor Akaun" />
            </div>

            <:actions>
              <div class="flex justify-end mt-6 space-x-4">
                <.button
                  class="bg-blue-600 text-white px-6 py-2 rounded-lg shadow hover:bg-blue-700"
                  phx-disable-with="Menyimpan..."
                >
                  Simpan
                </.button>
              </div>
            </:actions>
          </.simple_form>
        </div>
      </div>
    </div>
    """
  end

end

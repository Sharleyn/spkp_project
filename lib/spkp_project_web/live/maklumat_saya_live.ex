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
     |> assign(:current_path, "")}
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
    <div class="flex min-h-screen bg-gray-100">
      <!-- Sidebar -->
      <.live_component
        module={SpkpProjectWeb.SidebarComponent}
        id="sidebar"
        role={@current_user.role}
        current_path={@current_path}
      />

      <!-- Main Content -->
      <div class="flex-1 p-6">
        <h1 class="text-2xl font-bold mb-6">Maklumat Saya</h1>

        <.simple_form
          for={@changeset}
          as={:maklumat_pekerja}
          id="maklumat-form"
          phx-submit="save"
          phx-change="validate"
          :let={f}
        >
          <div class="grid grid-cols-1 gap-4">

            <.input
              name="user_name"
              value={@maklumat_pekerja.user.full_name}
              label="Nama Penuh"
              readonly
            />

              <.input
                name="user_email"
                value={@maklumat_pekerja.user.email}
                label="Email"
                readonly
              />

            <.input field={f[:no_ic]} type="text" label="Nombor IC" class="md:col-span-2" />
            <.input field={f[:no_tel]} type="text" label="Nombor Telefon" />
            <.input field={f[:nama_bank]} type="text" label="Nama Bank" />
            <.input field={f[:no_akaun]} type="text" label="Nombor Akaun" />
          </div>


          <:actions>
            <.button phx-disable-with="Menyimpan...">Simpan</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end
end

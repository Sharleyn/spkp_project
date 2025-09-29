defmodule SpkpProjectWeb.ElaunPekerjaLive.FormComponent do
  use SpkpProjectWeb, :live_component

  alias SpkpProject.Elaun
  import Phoenix.LiveView

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage elaun_pekerja records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="elaun_pekerja-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:nama_pekerja]}
          type="text"
          label="Nama Pekerja"
          value={@elaun_pekerja.maklumat_pekerja.user.full_name}
        />
        <.input field={@form[:tarikh_mula]} type="date" label="Tarikh mula" />
        <.input field={@form[:tarikh_akhir]} type="date" label="Tarikh akhir" />
        <.input
          field={@form[:status_permohonan]}
          type="select"
          label="Status Permohonan"
          prompt="-- Pilih status --"
          options={[
            {"Menunggu Kelulusan", "submitted"},
            {"Diterima", "diterima"},
            {"Ditolak", "ditolak"}
          ]}
        />
        <.input field={@form[:jumlah_keseluruhan]} type="number" label="Jumlah keseluruhan" step="any" />

        <%= if @role == "admin" and String.downcase(Phoenix.HTML.Form.input_value(@form, :status_permohonan) || "") == "diterima" do %>
          <div class="mt-4">
            <label class="block text-sm font-medium text-gray-700">Muat Naik Resit</label>
            <.live_file_input upload={@uploads.resit} />
          </div>
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving...">Save Elaun pekerja</.button>

          <.link
            navigate={@patch || ~p"/admin/elaun_pekerja"}
            class="ml-2 inline-flex items-center px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
          >
            Kembali
          </.link>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{elaun_pekerja: elaun_pekerja} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:role, fn -> "pekerja" end)
     |> allow_upload(:resit,
     accept: ~w(.pdf .jpg .png),
     max_entries: 1,
     max_file_size: 5_000_000
     )
     |> assign_new(:form, fn ->
       to_form(Elaun.change_elaun_pekerja(elaun_pekerja))
     end)}
  end

  @impl true
  def handle_event("validate", %{"elaun_pekerja" => elaun_pekerja_params}, socket) do
    changeset = Elaun.change_elaun_pekerja(socket.assigns.elaun_pekerja, elaun_pekerja_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"elaun_pekerja" => elaun_pekerja_params}, socket) do
    save_elaun_pekerja(socket, socket.assigns.action, elaun_pekerja_params)
  end

  defp save_elaun_pekerja(socket, :edit, elaun_pekerja_params) do
    # Ambil fail upload kalau ada
    uploaded_files =
      consume_uploaded_entries(socket, :resit, fn %{path: path}, _entry ->
        filename = Path.basename(path)
        dest = Path.join(["uploads", filename])
        File.cp!(path, dest)   # salin file
        {:ok, filename}
      end)

    # Kalau ada fail baru, masukkan ke params
    elaun_pekerja_params =
      case uploaded_files do
        [file | _] -> Map.put(elaun_pekerja_params, "resit", file)
        _ -> elaun_pekerja_params
      end

    case Elaun.update_elaun_pekerja(socket.assigns.elaun_pekerja, elaun_pekerja_params) do
      {:ok, elaun_pekerja} ->
        notify_parent({:saved, elaun_pekerja})

        {:noreply,
         socket
         |> put_flash(:info, "Elaun pekerja updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end


  defp save_elaun_pekerja(socket, :new, elaun_pekerja_params) do
    case Elaun.create_elaun_pekerja(elaun_pekerja_params) do
      {:ok, elaun_pekerja} ->
        notify_parent({:saved, elaun_pekerja})

        {:noreply,
         socket
         |> put_flash(:info, "Elaun pekerja created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

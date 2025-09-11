defmodule SpkpProjectWeb.ElaunPekerjaLive.FormComponent do
  use SpkpProjectWeb, :live_component

  alias SpkpProject.Elaun

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
            {"Menunggu Kelulusan", "Menunggu Kelulusan"},
            {"Diterima", "Diterima"},
            {"Ditolak", "Ditolak"}
          ]}
        />
        <.input field={@form[:jumlah_keseluruhan]} type="number" label="Jumlah keseluruhan" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Elaun pekerja</.button>
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

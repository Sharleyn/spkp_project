defmodule SpkpProjectWeb.KursussLive.FormComponent do
  use SpkpProjectWeb, :live_component

  alias SpkpProject.Kursus

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage kursuss records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="kursuss-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:nama_kursus]} type="text" label="Nama kursus" />
        <.input field={@form[:tarikh_mula]} type="date" label="Tarikh mula" />
        <.input field={@form[:tarikh_akhir]} type="date" label="Tarikh akhir" />
        <.input field={@form[:tempat]} type="text" label="Tempat" />
        <.input field={@form[:status_kursus]} type="text" label="Status kursus" />
        <.input field={@form[:had_umur]} type="number" label="Had umur" />
        <.input field={@form[:anjuran]} type="text" label="Anjuran" />
        <.input field={@form[:gambar_anjuran]} type="text" label="Gambar anjuran" />
        <.input field={@form[:gambar_kursus]} type="text" label="Gambar kursus" />
        <.input field={@form[:syarat_penyertaan]} type="text" label="Syarat penyertaan" />
        <.input field={@form[:syarat_pendidikan]} type="text" label="Syarat pendidikan" />
        <.input field={@form[:kuota]} type="number" label="Kuota" />
        <.input field={@form[:tarikh_tutup]} type="date" label="Tarikh tutup" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Kursuss</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{kursuss: kursuss} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Kursus.change_kursuss(kursuss))
     end)}
  end

  @impl true
  def handle_event("validate", %{"kursuss" => kursuss_params}, socket) do
    changeset = Kursus.change_kursuss(socket.assigns.kursuss, kursuss_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"kursuss" => kursuss_params}, socket) do
    save_kursuss(socket, socket.assigns.action, kursuss_params)
  end

  defp save_kursuss(socket, :edit, kursuss_params) do
    case Kursus.update_kursuss(socket.assigns.kursuss, kursuss_params) do
      {:ok, kursuss} ->
        notify_parent({:saved, kursuss})

        {:noreply,
         socket
         |> put_flash(:info, "Kursuss updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_kursuss(socket, :new, kursuss_params) do
    case Kursus.create_kursuss(kursuss_params) do
      {:ok, kursuss} ->
        notify_parent({:saved, kursuss})

        {:noreply,
         socket
         |> put_flash(:info, "Kursuss created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

defmodule SpkpProjectWeb.KursusKategoriLive.FormComponent do
  use SpkpProjectWeb, :live_component

  alias SpkpProject.Kursus

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Gunakan borang ini untuk menguruskan rekod Kursus Kategori dalam pangkalan data anda.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="kursus_kategori-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:kategori]} type="text" label="Kategori" />
        <:actions>
          <.button phx-disable-with="Saving...">Simpan Kursus kategori</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{kursus_kategori: kursus_kategori} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Kursus.change_kursus_kategori(kursus_kategori))
     end)}
  end

  @impl true
  def handle_event("validate", %{"kursus_kategori" => kursus_kategori_params}, socket) do
    changeset = Kursus.change_kursus_kategori(socket.assigns.kursus_kategori, kursus_kategori_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"kursus_kategori" => kursus_kategori_params}, socket) do
    save_kursus_kategori(socket, socket.assigns.action, kursus_kategori_params)
  end

  defp save_kursus_kategori(socket, :edit, kursus_kategori_params) do
    case Kursus.update_kursus_kategori(socket.assigns.kursus_kategori, kursus_kategori_params) do
      {:ok, kursus_kategori} ->
        notify_parent({:saved, kursus_kategori})

        {:noreply,
         socket
         |> put_flash(:info, "Kursus Kategori Berjaya Di Kemaskini")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_kursus_kategori(socket, :new, kursus_kategori_params) do
    case Kursus.create_kursus_kategori(kursus_kategori_params) do
      {:ok, kursus_kategori} ->
        notify_parent({:saved, kursus_kategori})

        {:noreply,
         socket
         |> put_flash(:info, "Kursus Kategori Berjaya Di Cipta")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

defmodule SpkpProjectWeb.ItemElaunPekerjaLive.FormComponent do
  use SpkpProjectWeb, :live_component

  alias SpkpProject.Elaun

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage item_elaun_pekerja records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="item_elaun_pekerja-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:kenyataan_tuntutan]} type="text" label="Kenyataan tuntutan" />
        <.input field={@form[:tarikh_tuntutan]} type="date" label="Tarikh tuntutan" />
        <.input field={@form[:masa_mula]} type="time" label="Masa mula" />
        <.input field={@form[:masa_tamat]} type="time" label="Masa tamat" />
        <.input field={@form[:keterangan]} type="text" label="Keterangan" />
        <.input field={@form[:jumlah]} type="number" label="Jumlah" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Item elaun pekerja</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{item_elaun_pekerja: item_elaun_pekerja} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Elaun.change_item_elaun_pekerja(item_elaun_pekerja))
     end)}
  end

  @impl true
  def handle_event("validate", %{"item_elaun_pekerja" => item_elaun_pekerja_params}, socket) do
    changeset = Elaun.change_item_elaun_pekerja(socket.assigns.item_elaun_pekerja, item_elaun_pekerja_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"item_elaun_pekerja" => item_elaun_pekerja_params}, socket) do
    save_item_elaun_pekerja(socket, socket.assigns.action, item_elaun_pekerja_params)
  end

  defp save_item_elaun_pekerja(socket, :edit, item_elaun_pekerja_params) do
    case Elaun.update_item_elaun_pekerja(socket.assigns.item_elaun_pekerja, item_elaun_pekerja_params) do
      {:ok, item_elaun_pekerja} ->
        notify_parent({:saved, item_elaun_pekerja})

        {:noreply,
         socket
         |> put_flash(:info, "Item elaun pekerja updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_item_elaun_pekerja(socket, :new, item_elaun_pekerja_params) do
    case Elaun.create_item_elaun_pekerja(item_elaun_pekerja_params) do
      {:ok, item_elaun_pekerja} ->
        notify_parent({:saved, item_elaun_pekerja})

        {:noreply,
         socket
         |> put_flash(:info, "Item elaun pekerja created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

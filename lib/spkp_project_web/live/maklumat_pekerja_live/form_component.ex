defmodule SpkpProjectWeb.MaklumatPekerjaLive.FormComponent do
  use SpkpProjectWeb, :live_component

  alias SpkpProject.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage maklumat_pekerja records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="maklumat_pekerja-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:no_ic]} type="text" label="No ic" />
        <.input field={@form[:no_tel]} type="text" label="No tel" />
        <.input field={@form[:nama_bank]} type="text" label="Nama bank" />
        <.input field={@form[:no_akaun]} type="text" label="No akaun" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Maklumat pekerja</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{maklumat_pekerja: maklumat_pekerja} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Accounts.change_maklumat_pekerja(maklumat_pekerja))
     end)}
  end

  @impl true
  def handle_event("validate", %{"maklumat_pekerja" => maklumat_pekerja_params}, socket) do
    changeset = Accounts.change_maklumat_pekerja(socket.assigns.maklumat_pekerja, maklumat_pekerja_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"maklumat_pekerja" => maklumat_pekerja_params}, socket) do
    save_maklumat_pekerja(socket, socket.assigns.action, maklumat_pekerja_params)
  end

  defp save_maklumat_pekerja(socket, :edit, maklumat_pekerja_params) do
    case Accounts.update_maklumat_pekerja(socket.assigns.maklumat_pekerja, maklumat_pekerja_params) do
      {:ok, maklumat_pekerja} ->
        notify_parent({:saved, maklumat_pekerja})

        {:noreply,
         socket
         |> put_flash(:info, "Maklumat pekerja updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_maklumat_pekerja(socket, :new, maklumat_pekerja_params) do
    case Accounts.create_maklumat_pekerja(maklumat_pekerja_params) do
      {:ok, maklumat_pekerja} ->
        notify_parent({:saved, maklumat_pekerja})

        {:noreply,
         socket
         |> put_flash(:info, "Maklumat pekerja created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

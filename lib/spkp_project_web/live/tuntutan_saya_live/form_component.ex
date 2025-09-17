defmodule SpkpProjectWeb.TuntutanSayaLive.FormComponent do
  use SpkpProjectWeb, :live_component
  alias SpkpProject.Elaun
  alias SpkpProject.Elaun.ItemElaunPekerja


  @impl true
  def render(assigns) do
    ~H"""
    <div class="fixed inset-0 bg-black/40 z-50">
      <div class="mx-auto mt-20 w-full max-w-4xl rounded-lg bg-white p-8 shadow-lg">
        <h3 class="text-center text-base font-semibold text-gray-700">
          Tambah Item Tuntutan
        </h3>

        <.simple_form
          for={@form}
          id="item_elaun_pekerja-form"
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
          class="mt-6"
        >
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <.input field={@form[:kenyataan_tuntutan]} type="text" label="Kenyataan / Jenis kerja" class="md:col-span-2" />
            <.input field={@form[:tarikh_tuntutan]}
              type="date"
              label="Tarikh Tuntutan"
              min={@elaun.tarikh_mula}
              max={@elaun.tarikh_akhir} />
            <div></div>
            <.input field={@form[:masa_mula]} type="time" label="Masa mula" />
            <.input field={@form[:masa_tamat]} type="time" label="Masa tamat" />
            <.input field={@form[:keterangan]} type="text" label="Keterangan" class="md:col-span-2" />
            <.input field={@form[:jumlah]} type="number" label="Jumlah (RM)" readonly class="md:col-span-2 bg-gray-100" />
          </div>

          <:actions>
            <.button phx-disable-with="Saving...">Simpan</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  @impl true
  def update(%{item_elaun_pekerja: item} = assigns, socket) do
    item = item || %ItemElaunPekerja{}  # fallback struct kosong

    changeset = Elaun.change_item_elaun_pekerja(item)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:item_elaun_pekerja, item)
     |> assign(:form, to_form(changeset))}
  end



  @impl true
  def handle_event("validate", %{"item_elaun_pekerja" => params}, socket) do
    changeset =
      socket.assigns.item_elaun_pekerja
      |> Elaun.change_item_elaun_pekerja(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end


  def handle_event("save", %{"item_elaun_pekerja" => params}, socket) do
    params = Map.put(params, "elaun_pekerja_id", socket.assigns.elaun.id)

    case socket.assigns.action do
      :new ->
        case Elaun.create_item_elaun_pekerja(params) do
          {:ok, item} ->
            notify_parent({:saved, item})
            {:noreply,
             socket
             |> put_flash(:info, "Item berjaya ditambah")
             |> push_navigate(to: ~p"/pekerja/elaun/#{socket.assigns.elaun.id}")}

          {:error, cs} ->
            {:noreply, assign(socket, form: to_form(cs))}
        end

      :edit ->
        case Elaun.update_item_elaun_pekerja(socket.assigns.item_elaun_pekerja, params) do
          {:ok, item} ->
            notify_parent({:saved, item})
            {:noreply,
             socket
             |> put_flash(:info, "Item berjaya dikemaskini")
             |> push_navigate(to: ~p"/pekerja/elaun/#{socket.assigns.elaun.id}")}

          {:error, cs} ->
            {:noreply, assign(socket, form: to_form(cs))}
        end
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

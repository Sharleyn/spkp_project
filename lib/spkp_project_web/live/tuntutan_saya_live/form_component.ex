defmodule SpkpProjectWeb.TuntutanSayaLive.FormComponent do
  use SpkpProjectWeb, :live_component

  alias SpkpProject.Elaun

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <!-- Step 1: Tarikh mula/akhir -->
      <div :if={@step == 1} class="fixed inset-0 bg-black/40 z-50">
        <div class="mx-auto mt-32 w-full max-w-2xl rounded-lg bg-white p-8 shadow-lg">
          <h3 class="text-center text-sm font-semibold tracking-wide text-gray-700">
            TUNTUTAN ELAUN
          </h3>

          <form phx-submit="set_tarikh" phx-target={@myself} class="mt-6 space-y-5">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Tarikh Mula</label>
              <input type="date" name="tarikh_mula" value={@tarikh_mula}
                     class="w-full rounded-md border border-gray-300 px-3 py-2
                            focus:outline-none focus:ring-2 focus:ring-blue-500" />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Tarikh Akhir</label>
              <input type="date" name="tarikh_akhir" value={@tarikh_akhir}
                     class="w-full rounded-md border border-gray-300 px-3 py-2
                            focus:outline-none focus:ring-2 focus:ring-blue-500" />
            </div>

            <div class="mt-8 flex justify-center">
              <button type="submit"
                class="rounded-md bg-blue-600 px-5 py-2 text-white hover:bg-blue-700">
                Seterusnya
              </button>
            </div>
          </form>
        </div>
      </div>

      <!-- Step 2: Butiran item -->
      <div :if={@step == 2} class="fixed inset-0 bg-black/40 z-50">
        <div class="mx-auto mt-20 w-full max-w-4xl rounded-lg bg-white p-8 shadow-lg">
          <h3 class="text-center text-sm font-semibold tracking-wide text-gray-700">
            TUNTUTAN ELAUN
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
              <.input field={@form[:tarikh_tuntutan]} type="date" label="Tarikh" />
              <div></div>
              <.input field={@form[:masa_mula]} type="time" label="Masa mula" />
              <.input field={@form[:masa_tamat]} type="time" label="Masa tamat" />
              <.input field={@form[:keterangan]} type="text" label="Keterangan" class="md:col-span-2" />
              <.input field={@form[:jumlah]} type="number" step="0.01" label="Jumlah (RM)" class="md:col-span-2" />
            </div>

            <:actions>
              <button type="button" phx-click="prev_step" phx-target={@myself}
                class="rounded-md bg-gray-500 px-5 py-2 text-white hover:bg-gray-600">Kembali</button>
                   <.button phx-disable-with="Saving...">Simpan</.button>
            </:actions>
          </.simple_form>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(%{item_elaun_pekerja: item_elaun_pekerja} = assigns, socket) do
  # ✅ pastikan preload
  item_elaun_pekerja =
    if assigns.action == :edit do
      # reload dengan preload relation
      Elaun.get_item_elaun_pekerja!(item_elaun_pekerja.id)
    else
      # kalau :new, jangan call Repo.get!
      item_elaun_pekerja
    end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:step, if(assigns.action == :edit, do: 2, else: 1))
     |> assign_new(:tarikh_mula, fn ->
      if assigns.action == :edit do
        item_elaun_pekerja.elaun_pekerja.tarikh_mula
      else
        nil
      end
    end)
    |> assign_new(:tarikh_akhir, fn ->
      if assigns.action == :edit do
        item_elaun_pekerja.elaun_pekerja.tarikh_akhir
      else
        nil
      end
    end)
     |> assign_new(:form, fn ->
       to_form(Elaun.change_item_elaun_pekerja(item_elaun_pekerja))
     end)}
  end

   # Step 1 → set tarikh
   @impl true
  def handle_event("set_tarikh", %{"tarikh_mula" => mula, "tarikh_akhir" => akhir}, socket) do
    {:noreply,
     socket
     |> assign(:tarikh_mula, mula)
     |> assign(:tarikh_akhir, akhir)
     |> assign(:step, 2)}
  end

  # Step 2 → validate item
  def handle_event("validate", %{"item_elaun_pekerja" => params}, socket) do
    changeset =
      Elaun.change_item_elaun_pekerja(socket.assigns.item_elaun_pekerja, params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("prev_step", _params, socket) do
    {:noreply, assign(socket, :step, 1)}
  end

  # Simpan kedua-dua table
  def handle_event("save", %{"item_elaun_pekerja" => item_params}, socket) do
    save_tuntutan(socket, socket.assigns.action, item_params)
  end

  defp save_tuntutan(socket, :new, item_params) do

     # cari rekod maklumat_pekerja untuk user yang sedang login
  maklumat_pekerja =
    SpkpProject.Accounts.get_maklumat_pekerja_by_user_id(socket.assigns.current_user.id)

    # buat elaun_pekerja dulu
    elaun_params = %{
      "tarikh_mula" => socket.assigns.tarikh_mula,
      "tarikh_akhir" => socket.assigns.tarikh_akhir,
      "status_permohonan" => "Menunggu Kelulusan",
      "jumlah_keseluruhan" => item_params["jumlah"],
      "maklumat_pekerja_id" => maklumat_pekerja.id   # ✅ guna id maklumat_pekerja

    }

    case Elaun.create_elaun_pekerja(elaun_params) do
      {:ok, elaun} ->
        # kaitkan item dengan elaun
        item_params = Map.put(item_params, "elaun_pekerja_id", elaun.id)

        case Elaun.create_item_elaun_pekerja(item_params) do
          {:ok, item} ->
            notify_parent({:saved, item})

            {:noreply,
             socket
             |> put_flash(:info, "Tuntutan berjaya disimpan")
             |> push_patch(to: socket.assigns.patch)}

          {:error, cs} ->
            {:noreply, assign(socket, form: to_form(cs))}
        end

      {:error, _cs} ->
        {:noreply, put_flash(socket, :error, "Gagal simpan elaun")}
    end
  end

  defp save_tuntutan(socket, :edit, item_params) do
    case Elaun.update_item_elaun_pekerja(socket.assigns.item_elaun_pekerja, item_params) do
      {:ok, item} ->
        notify_parent({:saved, item})

        {:noreply,
         socket
         |> put_flash(:info, "Item elaun pekerja dikemaskini")
         |> push_patch(to: socket.assigns.patch)}

      {:error, cs} ->
        {:noreply, assign(socket, form: to_form(cs))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

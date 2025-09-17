defmodule SpkpProjectWeb.TuntutanSayaLive.ElaunFormComponent do
  use SpkpProjectWeb, :live_component
  alias SpkpProject.Elaun
  alias SpkpProject.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div class="fixed inset-0 bg-black/40 z-50">
      <div class="mx-auto mt-20 w-full max-w-2xl rounded-lg bg-white p-8 shadow-lg">
        <h3 class="text-center text-base font-semibold text-gray-700">
          Buat Elaun Baru
        </h3>

        <.simple_form
          for={@form}
          id="elaun-form"
          phx-target={@myself}
          phx-submit="save"
          class="mt-6"
        >
          <.input field={@form[:tarikh_mula]} type="date" label="Tarikh Mula" />
          <.input field={@form[:tarikh_akhir]} type="date" label="Tarikh Akhir" />

          <:actions>
            <.button phx-disable-with="Saving...">Simpan Elaun</.button>

          <!-- ✅ Butang kembali -->
          <.link navigate={~p"/pekerja/item_elaun_pekerja"}
                 class="ml-2 bg-gray-500 text-white rounded-lg px-6 py-2 shadow-md hover:bg-gray-600">
            Kembali
          </.link>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    changeset = Elaun.change_elaun_pekerja(%Elaun.ElaunPekerja{})
    {:ok, socket |> assign(assigns) |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("save", %{"elaun_pekerja" => params}, socket) do
    maklumat = Accounts.get_maklumat_pekerja_by_user_id(socket.assigns.current_user.id)

    params =
      params
      |> Map.put("status_permohonan", "draft")
      |> Map.put("jumlah_keseluruhan", 0)
      |> Map.put("maklumat_pekerja_id", maklumat.id)

    case Elaun.create_elaun_pekerja(params) do
      {:ok, elaun} ->
        notify_parent({:saved, elaun})
        {:noreply,
         socket
         |> put_flash(:info, "Elaun berjaya dibuat")
         |> push_navigate(to: ~p"/pekerja/elaun/#{elaun.id}")}

      {:error, cs} ->
        {:noreply, assign(socket, form: to_form(cs))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

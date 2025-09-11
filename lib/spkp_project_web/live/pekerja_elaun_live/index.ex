defmodule SpkpProjectWeb.PekerjaElaunLive.Index do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Elaun
  alias SpkpProject.Repo

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    maklumat_pekerja =
      SpkpProject.Accounts.get_maklumat_pekerja_by_user_id(current_user.id)

    elaun_list =
      Elaun.list_elaun_pekerja()
      |> Enum.filter(&(&1.maklumat_pekerja_id == maklumat_pekerja.id))
      |> Repo.preload(:item_elaun_pekerja)

    {:ok, stream(socket, :elaun_saya, elaun_list)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-2xl font-bold mb-6">Elaun Saya</h1>

      <.table
        id="elaun_saya"
        rows={@streams.elaun_saya}
        row_click={fn {_id, elaun} -> JS.navigate(~p"/pekerja/elaun/#{elaun}") end}
      >
        <:col :let={{_id, elaun}} label="Tarikh Mula">{elaun.tarikh_mula}</:col>
        <:col :let={{_id, elaun}} label="Tarikh Akhir">{elaun.tarikh_akhir}</:col>
        <:col :let={{_id, elaun}} label="Status">{elaun.status_permohonan}</:col>
        <:col :let={{_id, elaun}} label="Jumlah (RM)">{elaun.jumlah_keseluruhan}</:col>

      </.table>
    </div>
    """
  end
end

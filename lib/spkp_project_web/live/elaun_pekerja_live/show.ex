defmodule SpkpProjectWeb.ElaunPekerjaLive.Show do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Elaun

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:elaun_pekerja, Elaun.get_elaun_pekerja!(id))}
  end

  defp page_title(:show), do: "Show Elaun pekerja"
  defp page_title(:edit), do: "Edit Elaun pekerja"

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Elaun pekerja {@elaun_pekerja.id}
      <:subtitle>This is a elaun_pekerja record from your database.</:subtitle>
      <:actions>
        <.link patch={~p"/admin/elaun_pekerja/#{@elaun_pekerja}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit elaun_pekerja</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Tarikh mula">{@elaun_pekerja.tarikh_mula}</:item>
      <:item title="Tarikh akhir">{@elaun_pekerja.tarikh_akhir}</:item>
      <:item title="Status permohonan">{@elaun_pekerja.status_permohonan}</:item>
      <:item title="Jumlah keseluruhan">{@elaun_pekerja.jumlah_keseluruhan}</:item>
    </.list>

    <.back navigate={~p"/admin/elaun_pekerja"}>Back to elaun_pekerja</.back>

    <.modal :if={@live_action == :edit} id="elaun_pekerja-modal" show on_cancel={JS.patch(~p"/admin/elaun_pekerja/#{@elaun_pekerja}")}>
      <.live_component
        module={SpkpProjectWeb.ElaunPekerjaLive.FormComponent}
        id={@elaun_pekerja.id}
        title={@page_title}
        action={@live_action}
        elaun_pekerja={@elaun_pekerja}
        patch={~p"/admin/elaun_pekerja/#{@elaun_pekerja}"}
      />
    </.modal>
    """
  end
end

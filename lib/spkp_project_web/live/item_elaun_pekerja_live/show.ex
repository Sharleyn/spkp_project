defmodule SpkpProjectWeb.ItemElaunPekerjaLive.Show do
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
     |> assign(:item_elaun_pekerja, Elaun.get_item_elaun_pekerja!(id))}
  end

  defp page_title(:show), do: "Show Item elaun pekerja"
  defp page_title(:edit), do: "Edit Item elaun pekerja"

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Item elaun pekerja {@item_elaun_pekerja.id}
      <:subtitle>This is a item_elaun_pekerja record from your database.</:subtitle>
      <:actions>
        <.link patch={~p"/admin/item_elaun_pekerja/#{@item_elaun_pekerja}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit item_elaun_pekerja</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Kenyataan tuntutan"><%= @item_elaun_pekerja.kenyataan_tuntutan %></:item>
      <:item title="Tarikh tuntutan"><%= @item_elaun_pekerja.tarikh_tuntutan %></:item>
      <:item title="Masa mula"><%= @item_elaun_pekerja.masa_mula %></:item>
      <:item title="Masa tamat"><%= @item_elaun_pekerja.masa_tamat %></:item>
      <:item title="Keterangan"><%= @item_elaun_pekerja.keterangan %></:item>
      <:item title="Jumlah"><%= @item_elaun_pekerja.jumlah %></:item>
    </.list>

    <.back navigate={~p"/admin/item_elaun_pekerja"}>Back to item_elaun_pekerja</.back>

    <.modal
      :if={@live_action == :edit}
      id="item_elaun_pekerja-modal"
      show
      on_cancel={JS.patch(~p"/admin/item_elaun_pekerja/#{@item_elaun_pekerja}")}
    >
      <.live_component
        module={SpkpProjectWeb.ItemElaunPekerjaLive.FormComponent}
        id={@item_elaun_pekerja.id}
        title={@page_title}
        action={@live_action}
        item_elaun_pekerja={@item_elaun_pekerja}
        patch={~p"/admin/item_elaun_pekerja/#{@item_elaun_pekerja}"}
      />
    </.modal>
    """
  end
end

defmodule SpkpProjectWeb.TuntutanSayaLive.Show do
  use SpkpProjectWeb, :live_view
  alias SpkpProject.Repo
  alias SpkpProject.Elaun


  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    elaun = Elaun.get_elaun_pekerja!(id) |> Repo.preload(:item_elaun_pekerja)
    {:noreply, assign(socket, elaun: elaun)}
  end

  @impl true
  def handle_info({:elaun_saved, elaun}, socket) do
    {:noreply, assign(socket, elaun: Repo.preload(elaun, :item_elaun_pekerja))}
  end

  def handle_info({:item_saved, _item}, socket) do
    elaun = Elaun.get_elaun_pekerja!(socket.assigns.elaun.id) |> Repo.preload(:item_elaun_pekerja)
    {:noreply, assign(socket, elaun: elaun)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>Tuntutan Elaun</h1>

      <.live_component
        module={SpkpProjectWeb.TuntutanSayaLive.FormComponent}
        id="tuntutan-form"
        elaun={@elaun}
      />

      <h2>Senarai Item</h2>
      <ul>
        <%= for item <- @elaun.item_elaun_pekerja do %>
          <li><%= item.kenyataan_tuntutan %> - RM <%= item.jumlah %></li>
        <% end %>
      </ul>
    </div>
    """
  end
end

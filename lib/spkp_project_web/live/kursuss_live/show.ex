defmodule SpkpProjectWeb.KursussLive.Show do
  use SpkpProjectWeb, :live_view
  alias SpkpProject.Kursus

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:kursuss, Kursus.get_kursuss!(id))}
  end

  defp page_title(:show), do: "Show Kursus"
  defp page_title(:edit), do: "Edit Kursus"

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      {@kursuss.nama_kursus}
      <:subtitle>Maklumat penuh kursus ini.</:subtitle>

      <:actions>
        <.link patch={~p"/admin/kursus/#{@kursuss}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit kursus</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Nama kursus">{@kursuss.nama_kursus}</:item>

      <:item title="Tarikh mula">{@kursuss.tarikh_mula}</:item>

      <:item title="Tarikh akhir">{@kursuss.tarikh_akhir}</:item>

      <:item title="Tempat">{@kursuss.tempat}</:item>

      <:item title="Status kursus">{@kursuss.status_kursus}</:item>

      <:item title="Kaedah Pembelajaran">{@kursuss.kaedah}</:item>

      <:item title="Had umur">{@kursuss.had_umur}</:item>

      <:item title="Anjuran">{@kursuss.anjuran}</:item>

      <:item title="Gambar anjuran">
        <%= if @kursuss.gambar_anjuran do %>
          <img src={@kursuss.gambar_anjuran} alt="Gambar anjuran" class="w-40 h-40 rounded-lg border" />
        <% else %>
          <span class="text-gray-400">Tiada gambar</span>
        <% end %>
      </:item>

      <:item title="Gambar kursus">
        <%= if @kursuss.gambar_kursus do %>
          <img src={@kursuss.gambar_kursus} alt="Gambar kursus" class="w-40 h-40 rounded-lg border" />
        <% else %>
          <span class="text-gray-400">Tiada gambar</span>
        <% end %>
      </:item>

      <:item title="Syarat penyertaan">{@kursuss.syarat_penyertaan}</:item>

      <:item title="Syarat pendidikan">{@kursuss.syarat_pendidikan}</:item>

      <:item title="Kuota">{@kursuss.kuota}</:item>

      <:item title="Tarikh tutup">{@kursuss.tarikh_tutup}</:item>
    </.list>

    <.back navigate={~p"/admin/kursus"}>Kembali ke senarai kursus</.back>

    <.modal
      :if={@live_action == :edit}
      id="kursuss-modal"
      show
      on_cancel={JS.patch(~p"/admin/kursus/#{@kursuss}")}
    >
      <.live_component
        module={SpkpProjectWeb.KursussLive.FormComponent}
        id={@kursuss.id}
        title={@page_title}
        action={@live_action}
        kursuss={@kursuss}
        patch={~p"/admin/kursus/#{@kursuss}"}
      />
    </.modal>
    """
  end
end

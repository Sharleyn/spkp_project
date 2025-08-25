defmodule SpkpProjectWeb.KursusKategoriLive.Show do
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
     |> assign(:kursus_kategori, Kursus.get_kursus_kategori!(id))}
  end

  defp page_title(:show), do: "Show Kursus kategori"
  defp page_title(:edit), do: "Edit Kursus kategori"

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Kursus kategori {@kursus_kategori.id}
      <:subtitle>Ini adalah rekod Kursus Kategori daripada pangkalan data anda.</:subtitle>
      <:actions>
        <.link patch={~p"/admin/kursus_kategori/#{@kursus_kategori}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit Kursus Kategori</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Kategori">{@kursus_kategori.kategori}</:item>
    </.list>

    <.back navigate={~p"/admin/kursus_kategori"}>Kembali ke Kursus Kategori</.back>

    <.modal :if={@live_action == :edit} id="kursus_kategori-modal" show on_cancel={JS.patch(~p"/admin/kursus_kategori/#{@kursus_kategori}")}>
      <.live_component
        module={SpkpProjectWeb.KursusKategoriLive.FormComponent}
        id={@kursus_kategori.id}
        title={@page_title}
        action={@live_action}
        kursus_kategori={@kursus_kategori}
        patch={~p"/admin/kursus_kategori/#{@kursus_kategori}"}
      />
    </.modal>
    """
  end
end

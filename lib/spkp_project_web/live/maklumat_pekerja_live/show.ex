defmodule SpkpProjectWeb.MaklumatPekerjaLive.Show do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:maklumat_pekerja, Accounts.get_maklumat_pekerja!(id))}
  end

  defp page_title(:show), do: "Show Maklumat pekerja"
  defp page_title(:edit), do: "Edit Maklumat pekerja"

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Maklumat pekerja {@maklumat_pekerja.id}
      <:subtitle>This is a maklumat_pekerja record from your database.</:subtitle>
      <:actions>
        <.link patch={~p"/admin/maklumat_pekerja/#{@maklumat_pekerja}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit maklumat_pekerja</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="No ic">{@maklumat_pekerja.no_ic}</:item>
      <:item title="No tel">{@maklumat_pekerja.no_tel}</:item>
      <:item title="Nama bank">{@maklumat_pekerja.nama_bank}</:item>
      <:item title="No akaun">{@maklumat_pekerja.no_akaun}</:item>
    </.list>

    <.back navigate={~p"/admin/maklumat_pekerja"}>Back to maklumat_pekerja</.back>

    <.modal
      :if={@live_action == :edit}
      id="maklumat_pekerja-modal"
      show
      on_cancel={JS.patch(~p"/admin/maklumat_pekerja/#{@maklumat_pekerja}")}
    >
      <.live_component
        module={SpkpProjectWeb.MaklumatPekerjaLive.FormComponent}
        id={@maklumat_pekerja.id}
        title={@page_title}
        action={@live_action}
        maklumat_pekerja={@maklumat_pekerja}
        patch={~p"/admin/maklumat_pekerja/#{@maklumat_pekerja}"}
      />
    </.modal>
    """
  end
end

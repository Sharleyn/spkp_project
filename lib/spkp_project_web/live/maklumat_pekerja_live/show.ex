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

  defp page_title(:show), do: "Maklumat Pekerja"
  defp page_title(:edit), do: "Edit Maklumat Pekerja"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full min-h-screen bg-gray-100 flex">
      <div class="flex-1 flex flex-col">
        <!-- Header -->
        <.header class="bg-white shadow-sm border-b border-gray-200">
          <div class="flex justify-between items-center px-6 py-4">
            <h1 class="text-2xl font-bold text-gray-800">Maklumat Pekerja</h1>
            <div>
              <.link patch={~p"/admin/maklumat_pekerja/#{@maklumat_pekerja}/show/edit"} phx-click={JS.push_focus()}>
                <.button>Edit</.button>
              </.link>
            </div>
          </div>
        </.header>

        <!-- Card Maklumat Pekerja -->
        <div class="bg-white shadow rounded-lg p-6 m-6">
          <h2 class="text-lg font-semibold text-gray-700 mb-4">Butiran Pekerja</h2>
          <.list>
            <:item title="Nama Penuh">{@maklumat_pekerja.user.full_name}</:item>
            <:item title="Email">{@maklumat_pekerja.user.email}</:item>
            <:item title="No IC">{@maklumat_pekerja.no_ic}</:item>
            <:item title="No Telefon">{@maklumat_pekerja.no_tel}</:item>
            <:item title="Nama Bank">{@maklumat_pekerja.nama_bank}</:item>
            <:item title="No Akaun">{@maklumat_pekerja.no_akaun}</:item>
          </.list>
        </div>

          <!-- Back Button -->
          <div class="px-6 mb-6">
            <.link
              navigate={~p"/admin/maklumat_pekerja"}
              class="inline-flex items-center px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
            >
              Kembali ke Senarai
            </.link>
          </div>


        <!-- Modal Edit -->
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
      </div>
    </div>
    """
  end
end

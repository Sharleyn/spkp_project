defmodule SpkpProjectWeb.KursusKategoriLive.Show do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Kursus

  @impl true
  def mount(_params, _session, socket) do
    role = socket.assigns.current_user.role
    {:ok, assign(socket, :role, role)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:kursus_kategori, Kursus.get_kursus_kategori!(id))}
  end

  defp page_title(:show), do: "Maklumat Kategori Kursus"
  defp page_title(:edit), do: "Kemaskini Kategori Kursus"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="px-8 py-6">
      <!-- Header -->
      <div class="flex items-center justify-between mb-6">
        <div>
          <h1 class="text-2xl font-bold text-gray-800">
            <%= @page_title %>
          </h1>
          <p class="text-gray-600 text-sm">
            Paparan maklumat kategori kursus dalam sistem.
          </p>
        </div>
        <div>
          <.link
            patch={~p"/admin/kursus_kategori/#{@kursus_kategori}/show/edit"}
            phx-click={JS.push_focus()}
          >
            <.button class="bg-blue-600 hover:bg-blue-700">✏️ Kemaskini</.button>
          </.link>
        </div>
      </div>

      <!-- Detail Card -->
      <div class="bg-white shadow-sm rounded-lg border p-6 mb-6">
        <h2 class="text-lg font-semibold text-gray-700 mb-4">Maklumat Kategori</h2>
        <dl class="space-y-3">
          <div class="flex justify-between border-b pb-2">
            <dt class="text-gray-600">ID</dt>
            <dd class="font-medium text-gray-900"><%= @kursus_kategori.id %></dd>
          </div>
          <div class="flex justify-between">
            <dt class="text-gray-600">Kategori</dt>
            <dd class="font-medium text-gray-900"><%= @kursus_kategori.kategori %></dd>
          </div>
        </dl>
      </div>

      <!-- Back Button -->
      <div>
        <.link navigate={~p"/admin/kursus_kategori"}>
          <.button class="bg-gray-500 hover:bg-gray-600">← Kembali ke Senarai</.button>
        </.link>
      </div>
    </div>

    <!-- Edit Modal -->
    <.modal
      :if={@live_action == :edit}
      id="kursus_kategori-modal"
      show
      on_cancel={JS.patch(~p"/admin/kursus_kategori/#{@kursus_kategori}")}>

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

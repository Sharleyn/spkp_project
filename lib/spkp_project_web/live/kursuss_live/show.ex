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

  defp page_title(:show), do: "Maklumat Kursus"
  defp page_title(:edit), do: "Kemaskini Kursus"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="px-8 py-6">
      <!-- Header -->
      <div class="flex items-center justify-between mb-6">
        <div>
          <h1 class="text-2xl font-bold text-gray-800">
            <%= @kursuss.nama_kursus %>
          </h1>
          <p class="text-gray-600 text-sm">Maklumat penuh kursus ini</p>
        </div>
        <div>
          <.link patch={~p"/admin/kursus/#{@kursuss}/show/edit"} phx-click={JS.push_focus()}>
            <.button class="bg-blue-600 hover:bg-blue-700">✏️ Kemaskini</.button>
          </.link>
        </div>
      </div>

      <!-- Detail Card -->
      <div class="bg-white shadow-sm rounded-lg border p-6 mb-6">
        <h2 class="text-lg font-semibold text-gray-700 mb-4">Butiran Kursus</h2>
        <dl class="space-y-3">
          <div class="flex justify-between border-b pb-2">
            <dt class="text-gray-600">Tarikh Mula</dt>
            <dd class="font-medium text-gray-900"><%= @kursuss.tarikh_mula %></dd>
          </div>
          <div class="flex justify-between border-b pb-2">
            <dt class="text-gray-600">Tarikh Akhir</dt>
            <dd class="font-medium text-gray-900"><%= @kursuss.tarikh_akhir %></dd>
          </div>
          <div class="flex justify-between border-b pb-2">
            <dt class="text-gray-600">Tempat</dt>
            <dd class="font-medium text-gray-900"><%= @kursuss.tempat %></dd>
          </div>
          <div class="flex justify-between border-b pb-2">
            <dt class="text-gray-600">Status</dt>
            <dd class="font-medium text-gray-900"><%= @kursuss.status_kursus %></dd>
          </div>
          <div class="flex justify-between border-b pb-2">
            <dt class="text-gray-600">Kaedah Pembelajaran</dt>
            <dd class="font-medium text-gray-900"><%= @kursuss.kaedah %></dd>
          </div>
          <div class="flex justify-between border-b pb-2">
            <dt class="text-gray-600">Had Umur</dt>
            <dd class="font-medium text-gray-900"><%= @kursuss.had_umur %></dd>
          </div>
          <div class="flex justify-between border-b pb-2">
            <dt class="text-gray-600">Anjuran</dt>
            <dd class="font-medium text-gray-900"><%= @kursuss.anjuran %></dd>
          </div>
        </dl>

        <!-- Images -->
        <div class="mt-6 grid grid-cols-1 md:grid-cols-2 gap-6">
        <%= if @kursuss.gambar_anjuran do %>
          <div>
            <img src={@kursuss.gambar_anjuran} class="w-48 h-48 rounded-lg border" />
            <div class="mt-2">
              <.link href={@kursuss.gambar_anjuran} target="_blank" class="text-blue-600 underline">
                Lihat Penuh
              </.link>
            </div>
          </div>
        <% else %>
          <span class="text-gray-400">Tiada gambar</span>
        <% end %>

          <div>
            <h3 class="text-gray-700 font-medium mb-2">Gambar Kursus</h3>
            <%= if @kursuss.gambar_kursus do %>
              <img src={@kursuss.gambar_kursus} alt="Gambar kursus" class="w-48 h-48 rounded-lg border" />
            <% else %>
              <span class="text-gray-400">Tiada gambar</span>
            <% end %>
          </div>
        </div>

        <!-- Extra Info -->
        <div class="mt-6 space-y-3">
          <div>
            <h3 class="text-gray-700 font-medium">Syarat Penyertaan</h3>
            <p class="text-gray-900"><%= @kursuss.syarat_penyertaan %></p>
          </div>
          <div>
            <h3 class="text-gray-700 font-medium">Syarat Pendidikan</h3>
            <p class="text-gray-900"><%= @kursuss.syarat_pendidikan %></p>
          </div>
          <div class="flex justify-between border-t pt-3">
            <dt class="text-gray-600">Kuota</dt>
            <dd class="font-medium text-gray-900"><%= @kursuss.kuota %></dd>
          </div>
          <div class="flex justify-between">
            <dt class="text-gray-600">Tarikh Tutup</dt>
            <dd class="font-medium text-gray-900"><%= @kursuss.tarikh_tutup %></dd>
          </div>

      <!-- Nota & Jadual Kursus -->
          <div class="mt-6 grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Nota Kursus -->
            <div>
              <h3 class="text-gray-700 font-medium mb-2">Nota Kursus</h3>
              <%= if @kursuss.nota_kursus do %>
                <div class="border rounded-lg overflow-hidden">
                  <iframe
                    src={@kursuss.nota_kursus}
                    type="application/pdf"
                  >
                    PDF tidak dapat dipaparkan.
                    <a href={@kursuss.nota_kursus} target="_blank">Muat Turun di sini</a>.
                  </iframe>
                </div>
              <% else %>
                <span class="text-gray-400">Tiada nota kursus</span>
              <% end %>
            </div>

            <!-- Jadual Kursus -->
            <div>
              <h3 class="text-gray-700 font-medium mb-2">Jadual Kursus</h3>
              <%= if @kursuss.jadual_kursus do %>
                <div class="border rounded-lg overflow-hidden">
                  <iframe
                    src={@kursuss.jadual_kursus}
                    type="application/pdf"
                  >
                    PDF tidak dapat dipaparkan.
                    <a href={@kursuss.jadual_kursus} target="_blank">Muat Turun di sini</a>.
                  </iframe>
                </div>
              <% else %>
                <span class="text-gray-400">Tiada jadual kursus</span>
              <% end %>
            </div>
          </div>
        </div>
      </div>

      <!-- Back Button -->
      <div>
        <.link navigate={~p"/admin/kursus"}>
          <.button class="bg-gray-500 hover:bg-gray-600">← Kembali ke Senarai Kursus</.button>
        </.link>
      </div>
    </div>

    <!-- Edit Modal -->
    <.modal
      :if={@live_action == :edit}
      id="kursuss-modal"
      show
      on_cancel={JS.patch(~p"/admin/kursus/#{@kursuss}")}>
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

defmodule SpkpProjectWeb.TuntutanSayaaLive do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Repo
  alias SpkpProject.Elaun
  alias SpkpProject.Elaun.{ElaunPekerja, ItemElaunPekerja}

  @impl true
  def mount(_params, session, socket) do
    role = session["role"] || "pekerja"
    current_path = socket.host_uri.path

    {:ok,
     socket
     |> assign(:role, role)
     |> assign(:current_path, current_path)
     |> assign(:elaun_changeset, ElaunPekerja.changeset(%ElaunPekerja{}, %{}))
     |> assign(:item_changeset, ItemElaunPekerja.changeset(%ItemElaunPekerja{}, %{}))
     |> assign(:elaun, nil)}
  end

  @impl true
  def handle_event("save_elaun", %{"elaun_pekerja" => elaun_params}, socket) do
    case Elaun.create_elaun_pekerja(elaun_params) do
      {:ok, elaun} ->
        elaun = Repo.preload(elaun, :item_elaun_pekerja)

        {:noreply,
         socket
         |> put_flash(:info, "Elaun berjaya didaftarkan")
         |> assign(:elaun, elaun)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :elaun_changeset, changeset)}
    end
  end

  @impl true
  def handle_event("save_item", %{"item_elaun_pekerja" => item_params}, socket) do
    elaun = socket.assigns[:elaun]
    params = Map.put(item_params, "elaun_pekerja_id", elaun.id)

    case Elaun.create_item_elaun_pekerja(params) do
      {:ok, _item} ->
        elaun = Repo.get!(ElaunPekerja, elaun.id) |> Repo.preload(:item_elaun_pekerja)

        {:noreply,
         socket
         |> put_flash(:info, "Item elaun berjaya ditambah")
         |> assign(:elaun, elaun)
         |> assign(:item_changeset, ItemElaunPekerja.changeset(%ItemElaunPekerja{}, %{}))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :item_changeset, changeset)}
    end
  end

  def handle_event("delete_item", %{"id" => id}, socket) do
    item = Elaun.get_item_elaun_pekerja!(id)
    {:ok, _} = Elaun.delete_item_elaun_pekerja(item)

    elaun =
      Repo.get!(ElaunPekerja, socket.assigns.elaun.id)
      |> Repo.preload(:item_elaun_pekerja)

    {:noreply,
     socket
     |> put_flash(:info, "Item elaun berjaya dipadam")
     |> assign(:elaun, elaun)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex">
      <!-- Sidebar -->
      <.live_component
        module={SpkpProjectWeb.SidebarComponent}
        id="sidebar"
        role={@role}
        current_path={@current_path}
        class="h-screen w-64 bg-gray-800 text-white"
      />

      <!-- Main Content -->
      <main class="flex-1 p-6">
        <h1 class="text-xl font-bold mb-4">Borang Tuntutan Elaun</h1>

        <!-- Borang Elaun -->
        <.form for={@elaun_changeset} phx-submit="save_elaun" class="space-y-4" :let={f}>
          <.input field={f[:tarikh_mula]} type="date" label="Tarikh Mula" />
          <.input field={f[:tarikh_akhir]} type="date" label="Tarikh Akhir" />
          <.input field={f[:status_permohonan]} type="text" label="Status Permohonan" />
          <.input field={f[:jumlah_keseluruhan]} type="number" step="0.01" label="Jumlah Keseluruhan" />

          <.button class="bg-blue-500 text-white px-4 py-2 rounded">Simpan Elaun</.button>
        </.form>

        <!-- Borang Item Elaun -->
        <%= if @elaun do %>
          <h2 class="text-lg font-semibold mt-6 mb-2">Tambah Item Elaun</h2>

          <.form for={@item_changeset} phx-submit="save_item" class="space-y-4" :let={f}>
            <.input field={f[:kenyataan_tuntutan]} type="text" label="Kenyataan Tuntutan" />
            <.input field={f[:tarikh_tuntutan]} type="date" label="Tarikh Tuntutan" />
            <.input field={f[:masa_mula]} type="time" label="Masa Mula" />
            <.input field={f[:masa_tamat]} type="time" label="Masa Tamat" />
            <.input field={f[:keterangan]} type="text" label="Keterangan" />
            <.input field={f[:jumlah]} type="number" step="0.01" label="Jumlah" />

            <.button class="bg-green-500 text-white px-4 py-2 rounded">Tambah Item</.button>
          </.form>

          <!-- Senarai Item Elaun -->
          <h2 class="text-lg font-semibold mt-6 mb-2">Senarai Item Tuntutan</h2>

          <%= if @elaun.item_elaun_pekerja == [] do %>
            <p class="text-gray-500 italic">Belum ada tuntutan dimasukkan.</p>
          <% else %>
            <table class="w-full border mt-2 text-sm">
              <thead>
                <tr class="bg-gray-100">
                  <th class="p-2 border">Tarikh</th>
                  <th class="p-2 border">Kenyataan</th>
                  <th class="p-2 border">Masa</th>
                  <th class="p-2 border">Jumlah (RM)</th>
                  <th class="p-2 border">Tindakan</th>
                </tr>
              </thead>
              <tbody>
                <%= for item <- @elaun.item_elaun_pekerja do %>
                  <tr>
                    <td class="p-2 border"><%= item.tarikh_tuntutan %></td>
                    <td class="p-2 border"><%= item.kenyataan_tuntutan %></td>
                    <td class="p-2 border"><%= item.masa_mula %> - <%= item.masa_tamat %></td>
                    <td class="p-2 border text-right"><%= item.jumlah %></td>
                    <td class="p-2 border text-center">
                      <button
                        phx-click="delete_item"
                        phx-value-id={item.id}
                        data-confirm="Padam item ini?"
                        class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded text-xs"
                      >
                        Padam
                      </button>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          <% end %>
        <% end %>
      </main>
    </div>
    """
  end
end

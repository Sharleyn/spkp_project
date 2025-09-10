defmodule SpkpProjectWeb.KursusKategoriLive.Index do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Kursus
  alias SpkpProject.Kursus.KursusKategori

  @impl true
  def mount(_params, _session, socket) do
    role = socket.assigns.current_user.role

  {:ok,
   socket
   |> assign(:role, role)
   |> stream(:kursus_kategori_collection, Kursus.list_kursus_kategori())}
  end

  @impl true
  def handle_params(params, uri, socket) do
    {:noreply,
    socket
    |> assign(:current_path, URI.parse(uri).path)
    |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Kursus kategori")
    |> assign(:kursus_kategori, Kursus.get_kursus_kategori!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Kursus kategori")
    |> assign(:kursus_kategori, %KursusKategori{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Kursus kategori")
    |> assign(:kursus_kategori, nil)
  end

  @impl true
  def handle_info(
        {SpkpProjectWeb.KursusKategoriLive.FormComponent, {:saved, kursus_kategori}},
        socket
      ) do
    {:noreply, stream_insert(socket, :kursus_kategori_collection, kursus_kategori)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    kursus_kategori = Kursus.get_kursus_kategori!(id)
    {:ok, _} = Kursus.delete_kursus_kategori(kursus_kategori)

    {:noreply, stream_delete(socket, :kursus_kategori_collection, kursus_kategori)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full min-h-screen bg-gray-100 flex">
      <!-- Sidebar -->
       <.live_component
        module={SpkpProjectWeb.SidebarComponent}
        id="sidebar"
        current_view={@socket.view}
        role={@current_user.role}
        current_user={@current_user}
        current_path={@current_path}
      />

      <!-- Main Content -->
      <div class="flex-1 flex flex-col">
        <.header class="bg-white shadow-sm border-b border-gray-200">
          <div class="flex justify-between items-center px-6 py-4">
            <div class="flex items-center space-x-4">
              <div class="flex items-center gap-4">
                <img src={~p"/images/a3.png"} alt="Logo" class="h-12" />
              </div>

              <h1 class="text-xl font-semibold text-gray-800">SPKP Admin Dashboard</h1>
            </div>

            <div class="flex items-center space-x-4">
              <span class="text-gray-600">admin@gmail.com</span>

                  <.link href={~p"/users/log_out"} method="delete" class="text-gray-600 hover:text-gray-800">
              Logout
              </.link>

              <div class="w-8 h-8 bg-gray-300 rounded-full"></div>
            </div>
          </div>
        </.header>
        <!-- Page Header -->
        <div class="flex items-center justify-between mb-8 px-10 py-6">
          <div>
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Kategori Kursus</h1>

            <p class="text-gray-600">Urus kursus mengikut kategori</p>
          </div>

          <.link patch={~p"/admin/kursus_kategori/new"}>
            <.button>Kategori Kursus Baru</.button>
          </.link>
        </div>

        <.table
          id="kursus_kategori"
          rows={@streams.kursus_kategori_collection}
          row_click={
            fn {_id, kursus_kategori} ->
              JS.navigate(~p"/admin/kursus_kategori/#{kursus_kategori}")
            end
          }
        >
          <:col :let={{_id, kursus_kategori}} label="Kategori">{kursus_kategori.kategori}</:col>

          <:action :let={{_id, kursus_kategori}}>
            <div class="sr-only">
              <.link navigate={~p"/admin/kursus_kategori/#{kursus_kategori}"}>Show</.link>
            </div>
             <.link patch={~p"/admin/kursus_kategori/#{kursus_kategori}/edit"}>Edit</.link>
          </:action>

          <:action :let={{id, kursus_kategori}}>
            <.link
              phx-click={JS.push("delete", value: %{id: kursus_kategori.id}) |> hide("##{id}")}
              data-confirm="Are you sure?"
            >
              Delete
            </.link>
          </:action>
        </.table>

        <.modal
          :if={@live_action in [:new, :edit]}
          id="kursus_kategori-modal"
          show
          on_cancel={JS.patch(~p"/admin/kursus_kategori")}
        >
          <.live_component
            module={SpkpProjectWeb.KursusKategoriLive.FormComponent}
            id={@kursus_kategori.id || :new}
            title={@page_title}
            action={@live_action}
            kursus_kategori={@kursus_kategori}
            patch={~p"/admin/kursus_kategori"}
            role={@role}
          />
        </.modal>
      </div>
    </div>
    """
  end
end

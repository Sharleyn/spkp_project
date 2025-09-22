defmodule SpkpProjectWeb.PermohonanLive.Show do
  use SpkpProjectWeb, :live_view
  alias SpkpProject.Userpermohonan.Userpermohonan
  alias SpkpProject.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    permohonan =
      Userpermohonan
      |> Repo.get!(id)
      |> Repo.preload([:kursus, user: :user_profile])

    {:noreply,
     socket
     |> assign(:permohonan, permohonan)
     |> assign(:page_title, page_title(socket.assigns.live_action))}
  end

  defp page_title(:show), do: "Maklumat Permohonan"
  defp page_title(:edit), do: "Edit Permohonan"


  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-2xl font-bold mb-6">Maklumat Permohonan</h1>

      <div class="bg-white shadow rounded-lg p-6 space-y-4">
          <p><strong>Nama Pemohon:</strong> <%= @permohonan.user.full_name %></p>
          <p><strong>Email:</strong> <%= @permohonan.user.email %></p>
          <p><strong>Kursus Dipohon:</strong> <%= @permohonan.kursus.nama_kursus %></p>
          <p><strong>Tarikh Permohonan:</strong> <%= Calendar.strftime(@permohonan.inserted_at, "%d-%m-%Y") %></p>
          <p><strong>Status:</strong> <%= @permohonan.status %></p>

          <%= if profile = @permohonan.user.user_profile do %>
            <hr class="my-4"/>
            <h2 class="text-xl font-semibold">Maklumat Profil Pengguna</h2>
            <p><strong>No. IC:</strong> <%= profile.ic %></p>
            <p><strong>Umur:</strong> <%= profile.age %></p>
            <p><strong>Jantina:</strong> <%= profile.gender %></p>
            <p><strong>No. Telefon:</strong> <%= profile.phone_number %></p>
            <p><strong>Alamat:</strong> <%= profile.address %></p>
            <p><strong>Daerah:</strong> <%= profile.district %></p>
            <p><strong>Pendidikan:</strong> <%= profile.education %></p>

            <%= if profile.ic_attachment do %>
              <p><strong>Lampiran IC:</strong>
                <a href={profile.ic_attachment} target="_blank" class="text-blue-600 underline">
                  Lihat Dokumen
                </a>
              </p>
            <% end %>
          <% end %>

          <%= if @permohonan.kursus && @permohonan.kursus.nota_kursus do %>
            <p><strong>Nota Kursus:</strong></p>
            <div class="border rounded-lg overflow-hidden h-96">
              <iframe
                src={@permohonan.kursus.nota_kursus}
                type="application/pdf"
                class="w-full h-full"
              >
                PDF tidak dapat dipaparkan.
                <a href={@permohonan.kursus.nota_kursus} target="_blank">Muat Turun</a>
              </iframe>
            </div>
          <% end %>


          <%= if @permohonan.kursus && @permohonan.kursus.jadual_kursus do %>
            <p><strong>Jadual Kursus:</strong>
              <a href={@permohonan.kursus.jadual_kursus} target="_blank" class="text-blue-600 underline">
                Lihat PDF
              </a>
            </p>
          <% end %>
        </div>


      <div class="mt-6 space-x-2">
        <.link patch={~p"/admin/permohonan"} class="bg-gray-600 text-white px-4 py-2 rounded">
          ← Kembali
        </.link>
        <.link patch={~p"/admin/permohonan/#{@permohonan.id}/show/edit"} class="bg-blue-600 text-white px-4 py-2 rounded">
          Edit
        </.link>
      </div>

      <!-- Modal untuk edit -->
        <%= if @live_action == :edit do %>
          <.modal
            id="permohonan-modal"
            show
            on_cancel={JS.patch(~p"/admin/permohonan/#{@permohonan.id}")}>
            <.live_component
              module={SpkpProjectWeb.PermohonanLive.FormComponent}
              id="permohonan-form"
              permohonan={@permohonan}
              action={@live_action}
              title="Edit Permohonan"
              patch={~p"/admin/permohonan/#{@permohonan.id}"}
            />
          </.modal>
        <% end %>

    </div>
    """
  end
end

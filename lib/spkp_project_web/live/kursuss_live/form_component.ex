defmodule SpkpProjectWeb.KursussLive.FormComponent do
  use SpkpProjectWeb, :live_component

  alias SpkpProject.Kursus

    @impl true
  def mount(socket) do
    {:ok,
    allow_upload(socket, :gambar_anjuran,
      accept: ~w(.jpg .jpeg .png),
      max_entries: 1
    )
    |> allow_upload(:gambar_kursus,
      accept: ~w(.jpg .jpeg .png),
      max_entries: 1
    )}
  end


  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage kursuss records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="kursuss-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:nama_kursus]} type="text" label="Nama kursus" />
        <.input field={@form[:tarikh_mula]} type="date" label="Tarikh mula" />
        <.input field={@form[:tarikh_akhir]} type="date" label="Tarikh akhir" />
        <.input field={@form[:tempat]} type="text" label="Tempat" />

        <.input
        field={@form[:status_kursus]}
        type="select"
        label="Status Kursus"
        prompt="-- Pilih status --"
        options={[
          {"Aktif", "Aktif"},
          {"Akan Datang", "Akan Datang"},
          {"Tamat", "Tamat"}
        ]}
        />

        <.input
          field={@form[:kursus_kategori_id]}
          type="select"
          label="Kategori Kursus"
          prompt="-- Pilih kategori --"
          options={Enum.map(@kursus_kategori, &{&1.kategori, &1.id})}
        />


        <.input field={@form[:had_umur]} type="number" label="Had umur" />

        <.input
          field={@form[:anjuran]}
          type="select"
          label="Anjuran"
          prompt="-- Pilih anjuran --"
          options={[
            {"JPSM", "JPSM"},
            {"KBS", "KBS"},
          ]}
        />



        <!-- Upload Gambar Anjuran -->
        <div class="mb-4">
          <label class="block font-semibold mb-2">Gambar Anjuran</label>

          <div class="mb-2 text-sm text-gray-600">
            <%= for entry <- @uploads.gambar_anjuran.entries do %>
              <div>
                <span><%= entry.client_name %></span>
                <span class="text-gray-400">(<%= entry.progress %>%)</span>
              </div>
            <% end %>
          </div>

          <.live_file_input upload={@uploads.gambar_anjuran} />
        </div>

        <!-- Upload Gambar Kursus -->
        <div class="mb-4">
          <label class="block font-semibold mb-2">Gambar Kursus</label>

          <!-- Senarai file dipilih -->
          <div class="mb-2 text-sm text-gray-600">
            <%= for entry <- @uploads.gambar_kursus.entries do %>
              <div>
                <span><%= entry.client_name %></span>
                <span class="text-gray-400">(<%= entry.progress %>%)</span>
              </div>
            <% end %>
          </div>

          <!-- Input upload -->
          <.live_file_input upload={@uploads.gambar_kursus} />
        </div>

        <.input field={@form[:syarat_penyertaan]} type="text" label="Syarat penyertaan" />

        <.input
          field={@form[:syarat_pendidikan]}
          type="select"
          label="Syarat Pendidikan"
          prompt="-- Pilih Pendidikan --"
          options={[
            {"SPM", "SPM"},
            {"DIPLOMA", "DIPLOMA"},
            {"DEGREE", "DEGREE"},
            {"MASTER", "MASTER"},
            {"PHD", "PHD"},
          ]}
        />

        <.input field={@form[:kuota]} type="number" label="Kuota" />
        <.input field={@form[:tarikh_tutup]} type="date" label="Tarikh tutup" />
        <:actions>
          <.button phx-disable-with="Saving...">Simpan</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{kursuss: kursuss} = assigns, socket) do
    kursus_kategori = SpkpProject.Kursus.list_kursus_kategori()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:kursus_kategori, kursus_kategori)
     |> assign_new(:form, fn ->
       to_form(Kursus.change_kursuss(kursuss))
     end)}
  end


  @impl true
  def handle_event("validate", %{"kursuss" => kursuss_params}, socket) do
    changeset = Kursus.change_kursuss(socket.assigns.kursuss, kursuss_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"kursuss" => kursuss_params}, socket) do
    save_kursuss(socket, socket.assigns.action, kursuss_params)
  end

  defp save_kursuss(socket, :edit, kursuss_params) do
    case Kursus.update_kursuss(socket.assigns.kursuss, kursuss_params) do
      {:ok, kursuss} ->
        notify_parent({:saved, kursuss})

        {:noreply,
         socket
         |> put_flash(:info, "Kursuss updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_kursuss(socket, :new, kursuss_params) do
    kursuss_params = save_uploads(socket, kursuss_params)

    case Kursus.create_kursuss(kursuss_params) do
      {:ok, kursuss} ->
        notify_parent({:saved, kursuss})


        {:noreply,
         socket
         |> put_flash(:info, "Kursuss created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_uploads(socket, params) do
    # gambar_anjuran
    gambar_anjuran =
      consume_uploaded_entries(socket, :gambar_anjuran, fn %{path: path}, _entry ->
        dest = Path.join(["priv/static/uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, "/uploads/#{Path.basename(dest)}"}
      end)
      |> List.first()

    # gambar_kursus
    gambar_kursus =
      consume_uploaded_entries(socket, :gambar_kursus, fn %{path: path}, _entry ->
        dest = Path.join(["priv/static/uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, "/uploads/#{Path.basename(dest)}"}
      end)
      |> List.first()

    params
    |> Map.put("gambar_anjuran", gambar_anjuran)
    |> Map.put("gambar_kursus", gambar_kursus)
  end


  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

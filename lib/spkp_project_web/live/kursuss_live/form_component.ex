defmodule SpkpProjectWeb.KursussLive.FormComponent do
  use SpkpProjectWeb, :live_component
  alias SpkpProject.Kursus

  @impl true
  def mount(socket) do
    {:ok,
    socket
    |> allow_upload(:gambar_anjuran,
      accept: ~w(.jpg .jpeg .png),
      max_entries: 1
    )
    |> allow_upload(:gambar_kursus,
      accept: ~w(.jpg .jpeg .png),
      max_entries: 1
    )
    |> allow_upload(:nota_kursus,
      accept: ~w(.pdf),
      max_entries: 1
    )
    |> allow_upload(:jadual_kursus,
      accept: ~w(.pdf),
      max_entries: 1
    )}
  end


  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Isi maklumat kursus.</:subtitle>
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
            {"Buka", "Buka"},
            {"Tutup", "Tutup"},
            {"Tamat", "Tamat"}
          ]}
        />
        <.input
          field={@form[:kursus_kategori_id]}
          type="select"
          label="Kategori Kursus"
          prompt="-- Pilih kategori --"
          options={Enum.map(@kursus_kategori, &{&1.kategori, &1.id})}
        /> <.input field={@form[:had_umur]} type="number" label="Had umur" />
        <.input
          field={@form[:anjuran]}
          type="select"
          label="Tajaan"
          prompt="-- Pilih tajaan --"
          options={[
            {"Jabatan Pembangunan Sumber Manusia", "Jabatan Pembangunan Sumber Manusia"},
            {"Kementerian Belia & Sukan Sabah", "Kementerian Belia & Sukan Sabah"}

          ]}
        />
        <.input
          field={@form[:kaedah]}
          type="select"
          label="Kaedah Pembelajaran"
          prompt="-- Pilih Kaedah Pembelajaran --"
          options={[
            {"Dalam Talian", "Dalam Talian"},
            {"Bersemuka", "Bersemuka"}

          ]}
        />
        <!-- Upload Gambar Tajaan -->
        <div class="mb-4">
          <label class="block font-semibold mb-2">Gambar Tajaan</label>
          <!-- Preview sebelum submit -->
          <%= for entry <- @uploads.gambar_anjuran.entries do %>
            <div class="mb-2">
              <.live_img_preview entry={entry} class="w-32 h-32 rounded-lg border" />
              <progress value={entry.progress} max="100">{entry.progress}%</progress>
            </div>
          <% end %>
          <!-- Gambar lama bila edit -->
          <%= if @kursuss.gambar_anjuran && @uploads.gambar_anjuran.entries == [] do %>
            <img src={@kursuss.gambar_anjuran} class="w-32 h-32 rounded-lg border" />
          <% end %>
          <!-- Input upload -->
          <.live_file_input upload={@uploads.gambar_anjuran} />
        </div>
        <!-- Upload Gambar Kursus -->
        <div class="mb-4">
          <label class="block font-semibold mb-2">Gambar Kursus</label>
          <!-- Preview sebelum submit -->
          <%= for entry <- @uploads.gambar_kursus.entries do %>
            <div class="mb-2">
              <.live_img_preview entry={entry} class="w-32 h-32 rounded-lg border" />
              <progress value={entry.progress} max="100">{entry.progress}%</progress>
            </div>
          <% end %>
          <!-- Gambar lama bila edit -->
          <%= if @kursuss.gambar_kursus && @uploads.gambar_kursus.entries == [] do %>
            <img src={@kursuss.gambar_kursus} class="w-32 h-32 rounded-lg border" />
          <% end %>
          <!-- Input upload -->
          <.live_file_input upload={@uploads.gambar_kursus} />
        </div>
         <.input field={@form[:syarat_penyertaan]} type="textarea" label="Syarat penyertaan" />
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
            {"PHD", "PHD"}
          ]}
        /> <.input field={@form[:kuota]} type="number" label="Kuota" />
        <.input field={@form[:tarikh_tutup]} type="date" label="Tarikh tutup" />
        <!-- Upload Nota Kursus -->
        <div class="mb-4">
          <label class="block font-semibold mb-2">Nota Kursus (PDF)</label>

          <%= for entry <- @uploads.nota_kursus.entries do %>
            <div class="mb-2">
              <p><%= entry.client_name %> (<%= entry.progress %>%)</p>
              <progress value={entry.progress} max="100"></progress>
            </div>
          <% end %>

          <%= if @kursuss.nota_kursus && @uploads.nota_kursus.entries == [] do %>
            <a href={@kursuss.nota_kursus} target="_blank" class="text-blue-600 underline">
              Lihat Nota Kursus
            </a>
          <% end %>

          <.live_file_input upload={@uploads.nota_kursus} />
        </div>

        <!-- Upload Jadual Kursus -->
        <div class="mb-4">
          <label class="block font-semibold mb-2">Jadual Kursus (PDF)</label>

          <%= for entry <- @uploads.jadual_kursus.entries do %>
            <div class="mb-2">
              <p><%= entry.client_name %> (<%= entry.progress %>%)</p>
              <progress value={entry.progress} max="100"></progress>
            </div>
          <% end %>

          <%= if @kursuss.jadual_kursus && @uploads.jadual_kursus.entries == [] do %>
            <a href={@kursuss.jadual_kursus} target="_blank" class="text-blue-600 underline">
              Lihat Jadual Kursus
            </a>
          <% end %>

          <.live_file_input upload={@uploads.jadual_kursus} />
        </div>

        <:actions>
        <.button phx-disable-with="Saving...">Simpan</.button>
          <.link
            navigate={@patch}
            class="ml-2 inline-flex items-center px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
          >
            Kembali
          </.link>
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
    kursuss_params = save_uploads(socket, kursuss_params)

    case Kursus.update_kursuss(socket.assigns.kursuss, kursuss_params) do
      {:ok, kursuss} ->
        notify_parent({:saved, kursuss})

        {:noreply,
         socket
         |> put_flash(:info, "Kursus berjaya dikemaskini")
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
         |> put_flash(:info, "Kursus berjaya dicipta")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  # Simpan fail ke priv/static/uploads + guna gambar lama kalau tiada upload baru
  defp save_uploads(socket, params) do

    gambar_anjuran =
      consume_uploaded_entries(socket, :gambar_anjuran, fn %{path: path}, _entry ->
        uploads_dir = Path.expand("./uploads")
        File.mkdir_p!(uploads_dir)

        dest = Path.join(uploads_dir, Path.basename(path))
        File.cp!(path, dest)
        {:ok, "/uploads/#{Path.basename(dest)}"}
      end)
      |> List.first()

    gambar_kursus =
      consume_uploaded_entries(socket, :gambar_kursus, fn %{path: path}, _entry ->
        uploads_dir = Path.expand("./uploads")
        File.mkdir_p!(uploads_dir)
        dest = Path.join(uploads_dir, Path.basename(path))
        File.cp!(path, dest)
        {:ok, "/uploads/#{Path.basename(dest)}"}
      end)
      |> List.first()

    nota_kursus =
      consume_uploaded_entries(socket, :nota_kursus, fn %{path: path}, entry ->
        uploads_dir = Path.expand("./uploads")
        File.mkdir_p!(uploads_dir)

        ext = Path.extname(entry.client_name)
        unique_name = "#{System.unique_integer([:positive])}#{ext}"
        dest = Path.join(uploads_dir, unique_name)

        File.cp!(path, dest)
        {:ok, "/uploads/#{unique_name}"}
      end)
      |> List.first()

    jadual_kursus =
      consume_uploaded_entries(socket, :jadual_kursus, fn %{path: path}, entry ->
        uploads_dir = Path.expand("./uploads")
        File.mkdir_p!(uploads_dir)

        ext = Path.extname(entry.client_name)
        unique_name = "#{System.unique_integer([:positive])}#{ext}"
        dest = Path.join(uploads_dir, unique_name)

        File.cp!(path, dest)
        {:ok, "/uploads/#{unique_name}"}
      end)
      |> List.first()

    params
    |> maybe_put("gambar_anjuran", gambar_anjuran, socket.assigns.kursuss.gambar_anjuran)
    |> maybe_put("gambar_kursus", gambar_kursus, socket.assigns.kursuss.gambar_kursus)
    |> maybe_put("nota_kursus", nota_kursus, socket.assigns.kursuss.nota_kursus)
    |> maybe_put("jadual_kursus", jadual_kursus, socket.assigns.kursuss.jadual_kursus)
  end

  defp maybe_put(params, key, new_val, old_val) do
    cond do
      # guna gambar baru
      is_binary(new_val) -> Map.put(params, key, new_val)
      # kekalkan gambar lama
      true -> Map.put(params, key, old_val)
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

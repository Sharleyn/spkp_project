defmodule SpkpProjectWeb.UserProfileLive do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Accounts
  alias SpkpProject.Accounts.UserProfile

  import Phoenix.LiveView
  import Phoenix.Component

  on_mount {SpkpProjectWeb.UserAuth, :ensure_authenticated}

  @gender_options ["Lelaki", "Perempuan"]

  @education_options [
    {"SPM", "SPM"},
    {"STPM", "STPM"},
    {"Diploma", "Diploma"},
    {"Ijazah Sarjana Muda", "Ijazah Sarjana Muda"},
    {"Ijazah Sarjana", "Ijazah Sarjana"},
    {"PhD", "PhD"},
    {"Sijil Kemahiran", "Sijil Kemahiran"}
  ]

  @district_options [
    "Beaufort",
    "Beluran",
    "Keningau",
    "Kota Belud",
    "Kota Kinabalu",
    "Kota Marudu",
    "Kuala Penyu",
    "Kudat",
    "Kunak",
    "Lahad Datu",
    "Nabawan",
    "Papar",
    "Penampang",
    "Pitas",
    "Putatan",
    "Ranau",
    "Sandakan",
    "Semporna",
    "Sipitang",
    "Tambunan",
    "Tawau",
    "Tenom",
    "Tongod",
    "Tuaran"
  ]

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    # Ambil existing profile atau buat baru
    profile = Accounts.get_user_profile_by_user_id(current_user.id) || %UserProfile{}

    # Buat changeset dengan data yang sedia ada
    profile_changeset =
      UserProfile.changeset(profile, %{
        full_name: current_user.full_name,
        email: current_user.email,
        user_id: current_user.id,
        ic: profile.ic,
        age: profile.age,
        gender: profile.gender,
        phone_number: profile.phone_number,
        address: profile.address,
        district: profile.district,
        education: profile.education,
        ic_attachment: profile.ic_attachment
      })

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:current_user_name, current_user.full_name)
      |> assign(:profile_changeset, profile_changeset)
      |> assign(:profile_form, to_form(profile_changeset))
      |> assign(:sidebar_open, true)
      |> assign(:user_menu_open, false)
      |> assign(:gender_options, @gender_options)
      |> assign(:education_options, @education_options)
      |> assign(:district_options, @district_options)
             |> allow_upload(:ic_attachment,
         accept: ~w(.jpg .jpeg .png .pdf),
         max_entries: 1
       )

    {:ok, socket}
  end

  # Handle validation
  def handle_event("validate", %{"user_profile" => profile_params}, socket) do
    changeset = UserProfile.changeset(socket.assigns.profile_changeset.data, profile_params)
    {:noreply, assign(socket, profile_form: to_form(changeset, action: :validate))}
  end

  # Save User (nama & email)
  def handle_event("save_profile", %{"user_profile" => profile_params}, socket) do
    current_user = socket.assigns.current_user

    # Debug logging for upload state
    IO.inspect(socket.assigns.uploads.ic_attachment.entries, label: "UPLOAD ENTRIES")
    IO.inspect(profile_params, label: "ORIGINAL PARAMS")

    # Process uploads using the working pattern from KursussLive.FormComponent
    profile_params = save_uploads(socket, profile_params, current_user.id)

    # Debug logging
    IO.inspect(profile_params, label: "FINAL PARAMS WITH UPLOADS")

    # Update user + user_profile
    case Accounts.update_user_profile(current_user, profile_params) do
      {:ok, updated_user} ->
        profile = Accounts.get_user_profile_by_user_id(updated_user.id) || %UserProfile{}

        profile_changeset =
          UserProfile.changeset(profile, %{
            full_name: updated_user.full_name,
            email: updated_user.email,
            user_id: updated_user.id,
            ic: profile.ic,
            age: profile.age,
            gender: profile.gender,
            phone_number: profile.phone_number,
            address: profile.address,
            district: profile.district,
            education: profile.education,
            ic_attachment: profile.ic_attachment
          })

        IO.inspect(profile_changeset, label: "profile_changeset")

        {:noreply,
         socket
         |> put_flash(:info, "Profil berjaya disimpan!")
         |> assign(:current_user, updated_user)
         |> assign(:current_user_name, updated_user.full_name)
         |> assign(:profile_changeset, profile_changeset)
         |> assign(:profile_form, to_form(profile_changeset))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Profil gagal disimpan. Sila semak input anda.")
         |> assign(:profile_changeset, changeset)
         |> assign(:profile_form, to_form(changeset))}
    end
  end

  # Events UI lain
  @impl true
  def handle_event("toggle_sidebar", _params, socket) do
    {:noreply, update(socket, :sidebar_open, &(!&1))}
  end

  @impl true
  def handle_event("toggle_user_menu", _params, socket) do
    {:noreply, update(socket, :user_menu_open, &(!&1))}
  end

  @impl true
  def handle_event("close_user_menu", _params, socket) do
    {:noreply, assign(socket, :user_menu_open, false)}
  end

  @impl true
  def handle_event("logout", _params, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Anda telah log keluar.")
     |> redirect(to: ~p"/lamanutama")}
  end

  defp nav_class(current, expected) do
    base =
      "flex items-center space-x-3 font-semibold p-3 rounded-xl transition-colors duration-200"

    if current == expected do
      # aktif
      base <> " bg-indigo-700 text-white"
    else
      # tidak aktif
      base <> " hover:bg-indigo-700 text-gray-300"
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white-100 min-h-screen antialiased text-gray-800">
      <!-- Burger Button -->
      <button
        class="p-2 rounded-lg text-white absolute top-4 left-4 focus:outline-none z-50"
        phx-click="toggle_sidebar"
      >
        <img src={~p"/images/burger3.png"} alt="Burger Icon" class="w-6 h-6" />
      </button>
      <!-- Sidebar -->
      <aside class={"fixed inset-y-0 left-0 z-40 w-64 p-6 flex flex-col items-start shadow-lg transition-transform duration-300 ease-in-out " <>
                    (if @sidebar_open, do: "translate-x-0", else: "-translate-x-full") <>
                    " bg-[#191970] text-white"}>
        <!-- Brand -->
        <div class="mt-4 mb-10 w-full">
          <div class="text-2xl text-center font-extrabold tracking-wide">SPKP</div>

          <div class="text-xs text-center font-bold text-indigo-200">
            Sistem Permohonan Kursus & Pengurusan
          </div>
        </div>
        <!-- Menu -->
        <nav class="w-full flex-grow">
          <ul class="space-y-4">
            <li>
              <.link
                navigate={~p"/userdashboard"}
                class={nav_class(@live_action, :dashboard)}
                aria-current={if @live_action == :dashboard, do: "page", else: nil}
              >
                <img src={~p"/images/right.png"} alt="Laman Utama" class="w-5 h-5" />
                <span>Laman Utama</span>
              </.link>
            </li>

            <li>
              <.link
                navigate={~p"/userprofile"}
                class={nav_class(@live_action, :profile)}
                aria-current={if @live_action == :profile, do: "page", else: nil}
              >
                <img src={~p"/images/right.png"} alt="Profil Saya" class="w-5 h-5" />
                <span>Profil Saya</span>
              </.link>
            </li>

            <li>
              <.link
                navigate={~p"/senaraikursususer"}
                class={nav_class(@live_action, :courses)}
                aria-current={if @live_action == :courses, do: "page", else: nil}
              >
                <img src={~p"/images/right.png"} alt="Senarai Kursus" class="w-5 h-5" />
                <span>Senarai Kursus</span>
              </.link>
            </li>

            <li>
              <.link
                navigate={~p"/permohonanuser"}
                class={nav_class(@live_action, :applications)}
                aria-current={if @live_action == :applications, do: "page", else: nil}
              >
                <img src={~p"/images/right.png"} alt="Permohonan Saya" class="w-5 h-5" />
                <span>Permohonan Saya</span>
              </.link>
            </li>
          </ul>
        </nav>
      </aside>
      <!-- Main content area -->
      <div class={"flex-grow p-6 transition-all duration-300 ease-in-out " <>
                         (if @sidebar_open, do: "md:ml-64", else: "md:ml-0 mx-auto")}>
        <!-- Top Header Bar -->
        <header class="flex justify-end items-center mb-6">
          <div class="relative">
            <!-- Button User -->
            <button
              phx-click="toggle_user_menu"
              class="flex items-center space-x-2 p-2 hover:bg-indigo-100 rounded-lg gap-6 transition-colors duration-200 focus:outline-none"
            >
              <img
                src={~p"/images/tableuser.png"}
                alt="User"
                class="w-8 h-8 rounded-full border border-gray-300"
              /> <span class="font-medium">{@current_user_name}</span>
              <img src={~p"/images/kotak - dropdown.png"} alt="Dropdown" />
            </button>
            <!-- Dropdown Menu -->
            <%= if @user_menu_open do %>
              <div class="absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-lg border border-gray-200 z-10">
                <!-- Setting -->
                <.link
                  navigate={~p"/users/settings"}
                  class="block px-4 py-2 text-sm text-black-700 hover:bg-gray-100 rounded-t-xl"
                >
                  Tetapan
                </.link>
                <!-- Logout -->
                <.link
                  href={~p"/halamanutama"}
                  method="delete"
                  class="block w-full text-left px-4 py-2 text-sm text-black-700 hover:bg-gray-100 rounded-b-xl"
                >
                  Log Keluar
                </.link>
              </div>
            <% end %>
          </div>
        </header>
        <!-- Main Content -->
        <h1 class="text-2xl font-bold mb-2">Profil Pengguna</h1>

        <p class="text-gray-600 mb-6">Kemaskini Maklumat Peribadi Anda Untuk Permohonan Kursus</p>
        <!-- Profile Pengguna Section -->
        <div class="border rounded-xl p-6 mb-6 bg-gray-50">
          <h3 class="font-semibold mb-4 text-center text-lg">Profil Pengguna</h3>

          <div class="text-center">
            <div class="w-20 h-20 bg-gray-100 rounded-full mx-auto mb-4 flex items-center justify-center">
              <img src={~p"/images/icons user.png"} alt="Profile Pengguna" class="w-30 h-30" />
            </div>

            <h4 class="text-xl font-semibold">{@current_user.full_name}</h4>

            <p class="text-gray-600">{@current_user.email}</p>
          </div>
        </div>
        <!-- Main Content -->
          <!-- Maklumat Asas -->
                 <.simple_form :let={f} for={@profile_form} id="user-profile-form" as={:user_profile} phx-change="validate" phx-submit="save_profile">
          <!-- Maklumat Asas -->
          <div class="border rounded-xl p-4">
            <h3 class="flex items-center font-semibold mb-4 space-x-2">
              <img src={~p"/images/carbonuser.png"} alt="Profile Pengguna" class="w-5 h-5" />
              <span>Maklumat Asas</span>
            </h3>

            <div class="grid grid-cols-2 gap-4">
              <.input field={f[:full_name]} type="text" label="Nama Penuh" />
              <.input field={f[:email]} type="email" label="Email" />
              <.input field={f[:ic]} type="text" label="No. Kad Pengenalan" />
              <.input field={f[:age]} type="number" label="Umur" />
              <.input field={f[:gender]} type="select" label="Jantina" options={@gender_options} />
            </div>
          </div>
          <!-- Maklumat Perhubungan -->
          <div class="border rounded-xl mt-4 p-4">
            <h3 class="flex items-center font-semibold mb-4 space-x-2">
              <img src={~p"/images/phonelinear.png"} alt="Maklumat Perhubungan" class="w-5 h-5" />
              <span>Maklumat Perhubungan</span>
            </h3>
            <.input field={f[:phone_number]} type="text" label="Telefon" />
            <.input field={f[:address]} type="textarea" label="Alamat" />
            <.input field={f[:district]} type="select" label="Daerah" options={@district_options} />
          </div>
          <!-- Pendidikan -->
          <div class="border rounded-xl mt-4 p-4">
            <h3 class="flex items-center font-semibold mb-4 space-x-2">
              <img src={~p"/images/bookeducation.png"} alt="Pendidikan" class="w-5 h-5" />
              <span>Pendidikan</span>
            </h3>

            <.input
              field={f[:education]}
              type="select"
              label="Pendidikan"
              options={@education_options}
            />
          </div>
                     <!-- Upload IC Attachment -->
           <div class="mb-4">
             <label class="block font-semibold mb-2">IC Attachment</label>

             <!-- Preview sebelum submit -->
             <%= for entry <- @uploads.ic_attachment.entries do %>
               <div class="mb-2">
                 <.live_img_preview entry={entry} class="w-32 h-32 rounded-lg border" />
                 <progress value={entry.progress} max="100"><%= entry.progress %>%</progress>
               </div>
             <% end %>

             <!-- Gambar lama bila edit -->
             <%= if @profile_changeset.data.ic_attachment && @uploads.ic_attachment.entries == [] do %>
               <%= if String.ends_with?(@profile_changeset.data.ic_attachment, [".jpg", ".jpeg", ".png"]) do %>
                 <img src={@profile_changeset.data.ic_attachment} class="w-32 h-32 rounded-lg border" />
               <% else %>
                 <a href={@profile_changeset.data.ic_attachment} target="_blank" class="text-blue-600 underline">
                   📄 Lihat fail IC lama
                 </a>
               <% end %>
             <% end %>

             <!-- Input upload -->
             <.live_file_input upload={@uploads.ic_attachment} />
           </div>
                     <:actions>
             <.button type="submit" class="bg-green-500 text-white px-6 py-2 rounded-xl hover:bg-green-600 transition">
               💾 Simpan Profil
             </.button>
           </:actions>
         </.simple_form>
      </div>
    </div>
    """
  end

    # Simpan fail ke priv/static/uploads + guna gambar lama kalau tiada upload baru
  defp save_uploads(socket, params, user_id) do
    ic_attachment =
      consume_uploaded_entries(socket, :ic_attachment, fn %{path: path}, _entry ->
        uploads_dir = Path.expand("./uploads")
        File.mkdir_p!(uploads_dir)
        dest = Path.join(uploads_dir, Path.basename(path))
        File.cp!(path, dest)
        {:ok, "/uploads/#{Path.basename(dest)}"}
      end)
      |> List.first()

    existing_profile = Accounts.get_user_profile_by_user_id(user_id) || %UserProfile{}

    result = params
    |> Map.put("user_id", user_id)
    |> maybe_put("ic_attachment", ic_attachment, existing_profile.ic_attachment)

    result
  end

  defp maybe_put(params, key, new_val, old_val) do
    cond do
      is_binary(new_val) -> Map.put(params, key, new_val) # guna gambar baru
      true -> Map.put(params, key, old_val)              # kekalkan gambar lama
    end
  end
end

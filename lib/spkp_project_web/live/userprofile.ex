defmodule SpkpProjectWeb.UserProfileLive do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Accounts
  alias SpkpProject.Accounts.UserProfile

  on_mount {SpkpProjectWeb.UserAuth, :ensure_authenticated}

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
    "Beaufort", "Beluran", "Keningau", "Kota Belud", "Kota Kinabalu", "Kota Marudu",
    "Kuala Penyu", "Kudat", "Kunak", "Lahad Datu", "Nabawan", "Papar", "Penampang",
    "Pitas", "Putatan", "Ranau", "Sandakan", "Semporna", "Sipitang", "Tambunan",
    "Tawau", "Tenom", "Tongod", "Tuaran"
  ]

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    # Get existing user profile or create new one
    profile = case Accounts.get_user_profile_by_user_id(current_user.id) do
      nil -> %UserProfile{}
      existing_profile -> existing_profile
    end

    user_changeset = Accounts.change_user_registration(current_user)
    profile_changeset = UserProfile.changeset(profile, %{})

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:current_user_name, current_user.full_name)
      |> assign(:user_changeset, user_changeset)
      |> assign(:profile_changeset, profile_changeset)
      |> assign(:user_form, to_form(user_changeset))
      |> assign(:profile_form, to_form(profile_changeset))
      |> assign(:education_options, @education_options)
      |> assign(:district_options, @district_options)
      |> assign(:sidebar_open, true)
      |> assign(:user_menu_open, false)

    {:ok, socket}
  end

  # Handle save untuk profile user
  @impl true
  def handle_event("save_profile", %{"user_profile" => profile_params}, socket) do
    params = Map.put(profile_params, "user_id", socket.assigns.current_user.id)

    case Accounts.create_or_update_user_profile(params) do
      {:ok, _profile} ->
        {:noreply, put_flash(socket, :info, "Profil berjaya dikemaskini")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :profile_changeset, changeset)}
    end
  end

  # Handle save untuk info user (contoh email, full_name)
  def handle_event("save_user", %{"user" => user_params}, socket) do
    user = socket.assigns.current_user

    case Accounts.update_user(user, user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Maklumat akaun berjaya dikemaskini")
         |> push_navigate(to: ~p"/userdashboard")}

      {:error, changeset} ->
        {:noreply, assign(socket, :user_changeset, changeset)}
    end
  end

  # Events UI lain
  def handle_event("toggle_sidebar", _params, socket) do
    {:noreply, update(socket, :sidebar_open, &(!&1))}
  end

  def handle_event("toggle_user_menu", _params, socket) do
    {:noreply, update(socket, :user_menu_open, &(!&1))}
  end

  def handle_event("close_user_menu", _params, socket) do
    {:noreply, assign(socket, :user_menu_open, false)}
  end

  def handle_event("logout", _params, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Anda telah log keluar.")
     |> redirect(to: ~p"/lamanutama")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white-100 min-h-screen antialiased text-gray-800">
      <!-- Burger Button -->
      <button class="p-2 rounded-lg text-white absolute top-4 left-4 focus:outline-none z-50"
         phx-click="toggle_sidebar">
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
            <li><.link navigate={~p"/userdashboard"} class="flex items-center space-x-3 font-semibold p-3 rounded-xl hover:bg-indigo-700 transition-colors duration-200"><span>Laman Utama</span></.link></li>
            <li><.link navigate={~p"/userprofile"} class="flex items-center space-x-3 font-semibold p-3 rounded-xl hover:bg-indigo-700 transition-colors duration-200"><span>Profil Saya</span></.link></li>
            <li><.link navigate={~p"/senaraikursususer"} class="flex items-center space-x-3 font-semibold p-3 rounded-xl hover:bg-indigo-700 transition-colors duration-200"><span>Senarai Kursus</span></.link></li>
            <li><.link navigate={~p"/permohonanuser"} class="flex items-center space-x-3 font-semibold p-3 rounded-xl hover:bg-indigo-700 transition-colors duration-200"><span>Permohonan Saya</span></.link></li>
          </ul>
        </nav>
      </aside>

      <!-- Main Content -->
      <div class="p-6 ml-64">
        <h1 class="text-2xl font-bold mb-2">Profil Pengguna</h1>
        <p class="text-gray-600 mb-6">Kemaskini Maklumat Peribadi Anda Untuk Permohonan Kursus</p>

        <!-- Profile Pengguna Section -->
        <div class="border rounded-xl p-6 mb-6 bg-gray-50">
          <h3 class="font-semibold mb-4 text-lg">👤 Profil Pengguna</h3>
          <div class="text-center">
            <div class="w-20 h-20 bg-gray-300 rounded-full mx-auto mb-4 flex items-center justify-center">
              <svg class="w-10 h-10 text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
              </svg>
            </div>
            <h4 class="text-xl font-semibold"><%= @current_user.full_name %></h4>
            <p class="text-gray-600"><%= @current_user.email %></p>
          </div>
        </div>

        <!-- Maklumat Asas Section -->
        <.form :let={f} for={@user_changeset} as={:user} phx-submit="save_user" class="space-y-6 mb-6">
          <div class="border rounded-xl p-4">
            <h3 class="font-semibold mb-4">📋 Maklumat Asas</h3>
            <div class="grid grid-cols-2 gap-4">
              <.input field={f[:full_name]} type="text" label="Nama Penuh" />
              <.input field={f[:email]} type="email" label="Email" />
            </div>
          </div>
        </.form>

        <!-- User Profile Form -->
        <.form :let={f} for={@profile_changeset} as={:user_profile} phx-submit="save_profile" class="space-y-6">
          <!-- Maklumat Asas -->
          <div class="border rounded-xl p-4">
            <h3 class="font-semibold mb-4">📋 Maklumat Asas</h3>
            <div class="grid grid-cols-2 gap-4">
              <.input field={f[:ic]} type="text" label="No. Kad Pengenalan" />
              <.input field={f[:age]} type="number" label="Umur" />
              <.input field={f[:gender]} type="select" label="Jantina" options={["Lelaki", "Perempuan"]} />
            </div>
          </div>

          <!-- Maklumat Perhubungan -->
          <div class="border rounded-xl p-4">
            <h3 class="font-semibold mb-4">📞 Maklumat Perhubungan</h3>
            <.input field={f[:phone_number]} type="text" label="Telefon" />
            <.input field={f[:address]} type="textarea" label="Alamat" placeholder="Masukkan alamat lengkap" />
            <.input field={f[:district]} type="select" label="Daerah" options={@district_options} />
          </div>

          <!-- Pendidikan -->
          <div class="border rounded-xl p-4">
            <h3 class="font-semibold mb-4">🎓 Pendidikan</h3>
            <.input field={f[:education]} type="select" label="Tahap Pendidikan" options={@education_options} prompt="Sila pilih tahap pendidikan anda" />
          </div>

          <!-- Lampiran Tambahan -->
          <div class="border rounded-xl p-4">
            <h3 class="font-semibold mb-4">📎 Lampiran Tambahan</h3>
            <div class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Salinan Kad Pengenalan
                </label>
                <div class="flex items-center justify-center w-full">
                  <label class="flex flex-col items-center justify-center w-full h-32 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100">
                    <div class="flex flex-col items-center justify-center pt-5 pb-6">
                      <svg class="w-8 h-8 mb-4 text-gray-500" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 16">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"/>
                      </svg>
                      <p class="mb-2 text-sm text-gray-500">
                        <span class="font-semibold">Klik untuk upload</span> atau drag and drop
                      </p>
                      <p class="text-xs text-gray-500">PDF, JPG, JPEG (MAX. 10MB)</p>
                    </div>
                    <input type="file" class="hidden" accept=".pdf,.jpg,.jpeg" />
                  </label>
                </div>
              </div>
            </div>
          </div>

          <!-- Button -->
          <div class="flex justify-center">
            <.button class="bg-green-500 text-white px-6 py-2 rounded-xl hover:bg-green-600 transition">
              💾 Simpan Profil
            </.button>
          </div>
        </.form>
      </div>
    </div>
    """
  end
end

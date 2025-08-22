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
    {"Sijil Kemahiran", "Sijil Kemahiran"}]

  @district_options [
    "Beaufort", "Beluran", "Keningau", "Kota Belud", "Kota Kinabalu", "Kota Marudu",
    "Kuala Penyu", "Kudat", "Kunak", "Lahad Datu", "Nabawan", "Papar", "Penampang",
    "Pitas", "Putatan", "Ranau", "Sandakan", "Semporna", "Sipitang", "Tambunan",
    "Tawau", "Tenom", "Tongod", "Tuaran"]

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    # Ambil existing profile atau buat baru
    profile = Accounts.get_user_profile_by_user_id(current_user.id) || %UserProfile{}

    # Buat changeset dengan data yang sedia ada
    profile_changeset = UserProfile.changeset(profile, %{
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

    {:ok,
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
     |> allow_upload(:ic_attachment, accept: ~w(.pdf .jpg .jpeg .png), max_entries: 1)}
  end

  # Save User (nama & email)
  @impl true
  def handle_event("save_profile", %{"user_profile" => profile_params}, socket) do
    # Tambah user_id ke params supaya hubungan has_one / belongs_to wujud
    params = Map.put(profile_params, "user_id", socket.assigns.current_user.id)

    # Handle upload fail IC
    uploaded_files =
      consume_uploaded_entries(socket, :ic_attachment, fn %{path: path}, entry ->
        filename = "#{System.system_time(:second)}_#{entry.client_name}"
        dest = Path.join(["priv/static/uploads", filename])
        File.cp!(path, dest)
        {:ok, "/uploads/#{filename}"}
      end)

    # Tambah path IC jika ada
    params = if uploaded_files != [], do: Map.put(params, "ic_attachment", List.first(uploaded_files)), else: params

    # Panggil Accounts.update_user_profile (update User + Profile)
    case Accounts.update_user_profile(socket.assigns.current_user, params) do
      {:ok, updated_user} ->
        # Reload profile untuk form
        profile = Accounts.get_user_profile_by_user_id(updated_user.id) || %UserProfile{}
        profile_changeset = UserProfile.changeset(profile, %{
          full_name: updated_user.full_name,
          email: updated_user.email,
          user_id: updated_user.id
        })

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
    base = "flex items-center space-x-3 font-semibold p-3 rounded-xl transition-colors duration-200"

    if current == expected do
      base <> " bg-indigo-700 text-white"  # aktif
    else
      base <> " hover:bg-indigo-700 text-gray-300" # tidak aktif
    end
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
            <li>
                <.link navigate={~p"/userdashboard"}
                   class={nav_class(@live_action, :dashboard)}
                   aria-current={if @live_action == :dashboard, do: "page", else: nil}>
              <img src={~p"/images/right.png"} alt="Laman Utama" class="w-5 h-5" />
              <span>Laman Utama</span>
            </.link>
          </li>

          <li>
            <.link navigate={~p"/userprofile"}
                   class={nav_class(@live_action, :profile)}
                   aria-current={if @live_action == :profile, do: "page", else: nil}>
              <img src={~p"/images/right.png"} alt="Profil Saya" class="w-5 h-5" />
              <span>Profil Saya</span>
            </.link>
          </li>

          <li>
            <.link navigate={~p"/senaraikursususer"}
                   class={nav_class(@live_action, :courses)}
                   aria-current={if @live_action == :courses, do: "page", else: nil}>
              <img src={~p"/images/right.png"} alt="Senarai Kursus" class="w-5 h-5" />
              <span>Senarai Kursus</span>
            </.link>
          </li>

          <li>
            <.link navigate={~p"/permohonanuser"}
                   class={nav_class(@live_action, :applications)}
                   aria-current={if @live_action == :applications, do: "page", else: nil}>
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
                                class="flex items-center space-x-2 p-2 hover:bg-indigo-100 rounded-lg gap-6 transition-colors duration-200 focus:outline-none">
                                      <img src={~p"/images/tableuser.png"} alt="User" class="w-8 h-8 rounded-full border border-gray-300" />
                                      <span class="font-medium"><%= @current_user_name %></span>
                                      <img src={~p"/images/kotak - dropdown.png"} alt="Dropdown" />
                     </button>

              <!-- Dropdown Menu -->
                     <%= if @user_menu_open do %>
                        <div class="absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-lg border border-gray-200 z-10">
                              <!-- Setting -->
                              <.link navigate={~p"/users/settings"}
                                 class="block px-4 py-2 text-sm text-black-700 hover:bg-gray-100 rounded-t-xl">
                                     Tetapan
                              </.link>

                              <!-- Logout -->
                              <.link href={~p"/halamanutama"} method="delete"
                                class="block w-full text-left px-4 py-2 text-sm text-black-700 hover:bg-gray-100 rounded-b-xl">
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
            <h4 class="text-xl font-semibold"><%= @current_user.full_name %></h4>
            <p class="text-gray-600"><%= @current_user.email %></p>
          </div>
        </div>

        <!-- Main Content -->
          <!-- Maklumat Asas -->
        <.form :let={f} for={@profile_form} as={:user_profile} phx-submit="save_profile">

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

                   <.input field={f[:education]} type="select" label="Pendidikan" options={@education_options} />
            </div>

          <!-- Lampiran Tambahan -->
               <div class="border rounded-xl p-4 mt-4">
                    <h3 class="flex items-center font-semibold mb-4 space-x-2">
                        <img src={~p"/images/upload.png"} class="w-5 h-5" />
                             <span>Lampiran Tambahan</span>
                     </h3>

               <!-- Label -->
                    <label class="block text-sm font-semibold mb-2 text-gray-700">
                           Salinan Kad Pengenalan
                    </label>

               <!-- Input Upload -->
                    <.live_file_input
                           upload={@uploads.ic_attachment}
                           class="block w-full text-sm text-gray-700 border border-gray-300
                           rounded-lg cursor-pointer bg-gray-50 focus:outline-none" />

               <!-- Senarai fail yang sedang diupload -->
                    <%= for entry <- @uploads.ic_attachment.entries do %>
                        <div class="mt-2 text-sm text-gray-600">
                        Uploading <%= entry.client_name %>... <%= entry.progress %>%
                       </div>
                     <% end %>

               <!-- Preview fail selepas save -->
                    <%= if @profile_form.data.ic_attachment do %>
                          <div class="mt-4">
                              <p class="text-sm font-medium text-gray-700 mb-2">Fail Semasa:</p>
                                 <%= if String.ends_with?(@profile_form.data.ic_attachment, [".jpg", ".jpeg", ".png"]) do %>
                                 <img src={@profile_form.data.ic_attachment} class="w-32 h-auto border rounded shadow-sm" />
                                <% else %>
                               <a href={@profile_form.data.ic_attachment}
                                  target="_blank"
                                  class="text-blue-600 underline">
                                  Lihat fail semasa
                              </a>
                            <% end %>
                         </div>
                      <% end %>
                    </div>

          <!-- Button -->
          <div class="flex justify-center mt-8">
            <.button type="submit" class="bg-green-500 text-white px-6 py-2 rounded-xl hover:bg-green-600 transition">
              💾 Simpan Profil
            </.button>
          </div>
        </.form>
      </div>
     </div>
    """
  end
end

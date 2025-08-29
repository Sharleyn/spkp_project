defmodule SpkpProjectWeb.ProgramKursusLive do
  use SpkpProjectWeb, :live_view

  alias SpkpProject.Kursus.Kursuss
  alias SpkpProject.Repo
  import Ecto.Query

  def mount(_params, _session, socket) do
    # Kursus Jangka Panjang (≥30 hari)
    long_courses =
      from(k in Kursuss,
        where: fragment("? - ? > 30", k.tarikh_akhir, k.tarikh_mula),
        order_by: [desc: k.tarikh_mula],
        limit: 4
      )
      |> Repo.all()

    # Kursus Jangka Pendek (<30 hari)
    short_courses =
      from(k in Kursuss,
        where: fragment("? - ? <= 30", k.tarikh_akhir, k.tarikh_mula),
        order_by: [desc: k.tarikh_mula],
        limit: 4
      )
      |> Repo.all()

    {:ok, assign(socket, long_courses: long_courses, short_courses: short_courses)}
  end

  def render(assigns) do
    ~H"""
    <head>
      <style>
        body {
          background-image: url("/images/background.jpg");
          background-size: cover;
          background-repeat: no-repeat;
          background-position: center;
        }
        html {
          scroll-behavior: smooth;}
      </style>
    </head>

    <div class="font-sans">
      <!-- Header -->
      <header class="transparent">
        <div class="max-w-7xl mx-auto flex items-center justify-between px-4 py-3">
          <div class="flex items-center">
            <img src={~p"/images/logo 1.png"} alt="Logo 1" style="height:90px;" class="mr-6" />
            <div class="flex gap-1 mt-10">
              <img src={~p"/images/logo 2.png"} alt="Logo 2" class="h-10" />
              <img src={~p"/images/logo 3.png"} alt="Logo 3" class="h-10" />
              <img src={~p"/images/logo 4.png"} alt="Logo 4" class="h-10" />
              <img src={~p"/images/logo 5.png"} alt="Logo 5" class="h-10" />
              <img src={~p"/images/logo 6.png"} alt="Logo 6" class="h-16" />
            </div>
          </div>

        <!-- Ikon kanan -->
        <div class="flex space-x-6">
          <!-- Pengguna -->
          <.link
            navigate={~p"/users/log_in"}
            class="flex flex-col items-center text-sm hover:opacity-80"
          >
            <img src={~p"/images/orang awam.png"} alt="Pengguna" class="h-8 w-8 mb-1" />
            <span>Pengguna</span>
          </.link>
          <!-- Admin -->
          <.link
            navigate={~p"/users/log_in"}
            class="flex flex-col items-center text-sm hover:opacity-80"
          >
            <img src={~p"/images/admin.png"} alt="Admin" class="h-8 w-8 mb-1" /> <span>Admin</span>
          </.link>
        </div>
      </div>
    </header>

    <!-- Navigasi -->
    <div class="bg-[#09033F] shadow py-2">
      <div class="max-w-7xl mx-auto flex space-x-2">
        <a
          href={~p"/"}
          class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded">
          Halaman Utama
        </a>
        <a
          href={~p"/mengenaikami"}
          class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded">
          Mengenai Kami
        </a>
        <a
          href={~p"/programkursus"}
          class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded">
          Program
        </a>
        <a
          href="/#hubungi"
          class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded">
          Hubungi
        </a>
      </div>
    </div>

    <div class="max-w-7xl mx-auto p-6">
      <h1 class="text-3xl font-bold mb-8 text-center text-gray-800">Kursus Ditawarkan</h1>

      <!-- Kursus Jangka Panjang -->
         <h3 class="text-lg font-semibold mb-4">Kursus Jangka Panjang</h3>
             <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-10">
                 <%= for course <- @long_courses do %>
                    <div class="bg-white shadow-lg rounded-xl p-3 border border-gray-200 hover:shadow-xl transition flex flex-col justify-between">
      <!-- Bahagian atas -->
           <div>
            <!-- Gambar Kursus -->
              <img src={course.gambar_kursus || "/images/default-course.jpg"} alt={"Gambar #{course.nama_kursus}"} class="w-full h-40 object-cover rounded-lg mb-4"/>

               <h3 class="text-sm font-bold text-gray-900 mb-2"><%= course.nama_kursus %></h3>

               <!-- Gambar Anjuran + Nama -->
                  <div class="flex items-center space-x-2 mt-3">
                    <img src={course.gambar_anjuran || "/images/default-logo.png"} alt="Logo Anjuran" class="w-12 h-12 rounded-full object-cover border"/>
                      <span class="text-xs text-gray-600">Tajaan: <%= course.anjuran %></span>
                 </div>

                 <p class="text-sm text-gray-600 mt-2 mb-2">Tempat: <%= course.tempat %></p>

                 <p class="text-xs text-gray-600">Tarikh: <%= course.tarikh_mula %> → <%= course.tarikh_akhir %></p>
            </div>

            <!-- Button di bawah -->
               <div class="mt-4">
                   <.link navigate={~p"/senaraikursususer"} class="px-2 py-1 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition">
                      Lihat lagi
                  </.link>
                </div>
              </div>
            <% end %>
          </div>

      <!-- Kursus Jangka Pendek -->
         <h3 class="text-lg font-semibold mb-4">Kursus Jangka Pendek</h3>
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
               <%= for course <- @short_courses do %>
                  <div class="bg-white shadow-lg rounded-xl p-3 border border-gray-200 hover:shadow-xl transition flex flex-col justify-between">

      <!-- Bahagian atas -->
           <div>
            <!-- Gambar Kursus -->
             <img src={course.gambar_kursus || "/images/default-course.jpg"} alt={"Gambar #{course.nama_kursus}"} class="w-full h-40 object-cover rounded-lg mb-4"/>

               <h3 class="text-sm font-bold text-gray-900 mb-2"><%= course.nama_kursus %></h3>

               <!-- Gambar Anjuran + Nama -->
                  <div class="flex items-center space-x-2 mt-3">
                   <img src={course.gambar_anjuran || "/images/default-logo.png"} alt="Logo Anjuran" class="w-12 h-12 rounded-full object-cover border"/>
                    <span class="text-xs text-gray-600">Tajaan: <%= course.anjuran %></span>
                 </div>

                  <p class="text-sm text-gray-600 mt-2 mb-2">Tempat: <%= course.tempat %></p>

                  <p class="text-xs text-gray-600">Tarikh: <%= course.tarikh_mula %> → <%= course.tarikh_akhir %></p>
           </div>

      <!-- Button di bawah -->
          <div class="mt-4">
            <.link navigate={~p"/senaraikursususer"} class="px-2 py-1 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition">
               Lihat lagi
            </.link>
         </div>
        </div>
       <% end %>
      </div>
     </div>
    </div>

    <!-- FOOTER -->
    <section id="hubungi">
      <footer class="bg-[#09033F] text-white mt-10 py-2 text-center">
        <p class="text-sm font-bold">SHARIF PERCHAYA SDN. BHD.</p>

        <div class="bg-[#09033F] text-white px-16 py-2 space-y-3 mx-auto text-left">
          <div class="flex items-center justify-between gap-6 flex-wrap">

            <!-- Alamat -->
            <div class="flex items-center gap-4">
              <img src={~p"/images/office.png"} alt="Alamat" class="h-6 w-6" />
              <p class="text-sm">
                Alamat: Block G. 2ND Floor, Lot 9, Lintas Jaya Uptownship Penampang, 88200 Sabah
              </p>
            </div>

            <!-- Telefon & Faks -->
            <div class="flex items-center gap-4">
              <img src={~p"/images/fax.png"} alt="Telefon & Faks" class="h-6 w-6" />
              <p class="text-sm">No. Tel: 011-3371 7129<br />Faks: 088 729717</p>
            </div>

            <!-- Email -->
            <div class="flex items-center gap-4">
              <img src={~p"/images/email.png"} alt="Email" class="h-6 w-6" />
              <p class="text-sm">Email: sharifperchaya@gmail.com</p>
            </div>

            <!-- FB -->
            <div class="flex items-center gap-4">
              <img src={~p"/images/fb.png"} alt="Facebook" class="h-6 w-6" />
              <p class="text-sm">Sharif Perchaya Sdn Bhd</p>
            </div>
          </div>

          <!-- Waktu Operasi -->
          <p class="text-sm text-center font-bold mt-4">MASA OPERASI</p>

          <div class="bg-[#09033F] flex items-start text-white max-w-xl mx-auto mt-4 text-left gap-2">
            <img src={~p"/images/clock.png"} alt="Waktu Operasi" class="h-6 w-6" />
            <p class="text-sm">
              Hari Bekerja: Isnin - Jumaat | 8:00 A.M. – 5:00 P.M. | Cuti: Sabtu, Ahad, Cuti Umum
            </p>
          </div>
        </div>
      </footer>
    </section>
    """
  end
end

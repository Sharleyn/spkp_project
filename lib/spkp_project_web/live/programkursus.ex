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
          Laman Utama
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
      <h1 class="text-4xl font-bold mb-8 text-center text-gray-800">Program</h1>

      <!-- Kursus Jangka Panjang -->
      <section class="mb-12">
        <h2 class="text-2xl font-semibold mb-4 text-gray-700">Kursus Jangka Panjang</h2>

        <div class="grid md:grid-cols-2 gap-6">
          <%= for course <- @long_courses do %>
            <div class="bg-white shadow-lg rounded-2xl p-6 border border-gray-200 hover:shadow-xl transition">
              <h3 class="text-lg font-bold text-gray-900 mb-2">{course.title}</h3>

              <p class="text-sm text-gray-600 mb-3">{course.description}</p>

              <p class="text-xs text-gray-500">Tarikh: {course.start} &rarr; {course.end}</p>

              <div class="mt-4">
                <!-- Belum login, redirect ke login -->
                <.link
                  navigate={~p"/users/log_in"}
                  class="px-5 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
                >
                  Mohon
                </.link>
              </div>
            </div>
          <% end %>
        </div>
      </section>

      <!-- Kursus Jangka Pendek -->
      <section>

        <h2 class="text-2xl font-semibold mb-4 text-gray-700">Kursus Jangka Pendek</h2>

        <div class="grid md:grid-cols-2 gap-6">
          <%= for course <- @short_courses do %>
            <div class="bg-white shadow-lg rounded-2xl p-6 border border-gray-200 hover:shadow-xl transition">
              <h3 class="text-lg font-bold text-gray-900 mb-2">{course.title}</h3>

              <p class="text-sm text-gray-600 mb-3">{course.description}</p>

              <p class="text-xs text-gray-500">Tarikh: {course.start} &rarr; {course.end}</p>

              <div class="mt-4">
                <!-- Belum login, redirect ke login -->
                <.link
                  navigate={~p"/users/log_in"}
                  class="px-5 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
                >
                  Mohon
                </.link>
              </div>
             </div>
            <% end %>
           </div>
         </section>
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

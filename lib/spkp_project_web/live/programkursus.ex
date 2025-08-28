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
          scroll-behavior: smooth;
        }
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

          <div class="flex space-x-6">
            <.link navigate={~p"/users/log_in"} class="flex flex-col items-center text-sm hover:opacity-80">
              <img src={~p"/images/orang awam.png"} alt="Pengguna" class="h-8 w-8 mb-1" />
              <span>Pengguna</span>
            </.link>

            <.link navigate={~p"/users/log_in"} class="flex flex-col items-center text-sm hover:opacity-80">
              <img src={~p"/images/admin.png"} alt="Admin" class="h-8 w-8 mb-1" />
              <span>Admin</span>
            </.link>
          </div>
        </div>
      </header>

      <!-- Navigation bar -->
      <div class="bg-[#09033F] shadow py-2">
        <div class="max-w-7xl mx-auto flex space-x-2">
          <a href={~p"/"} class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded">Laman Utama</a>
          <a href={~p"/mengenaikami"} class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded">Mengenai Kami</a>
          <a href={~p"/programkursus"} class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded">Program</a>
          <a href="/#hubungi" class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded">Hubungi</a>
        </div>
      </div>

    <div class="max-w-7xl mx-auto p-6">

      <h1 class="text-4xl font-bold mb-8 text-center text-gray-800">Kursus Ditawarkan</h1>

      <!-- Kursus Jangka Panjang -->
      <section class="mb-12">
        <h2 class="text-2xl font-semibold mb-4 text-black-500">Kursus Jangka Panjang</h2>
        <div class="grid md:grid-cols-4 gap-6">
          <%= for course <- @long_courses do %>
            <div class="bg-white shadow-lg rounded-2xl overflow-hidden border border-gray-200 hover:shadow-xl transition">
              <img src={course.gambar_kursus} alt={course.nama_kursus} class="w-full h-48 object-cover" />
              <div class="p-6">
                <h3 class="text-lg font-bold text-gray-900 mb-2"><%= course.nama_kursus %></h3>
                <div class="flex items-center gap-2 mb-2">
                  <img src={course.gambar_anjuran} alt={course.anjuran} class="h-8 w-8 rounded-full" />
                  <p class="text-sm text-gray-600">Tajaan: <%= course.anjuran %></p>
                </div>
                <p class="text-xs text-gray-500 mb-1">Tempat: <%= course.tempat %></p>
                <p class="text-xs text-gray-500 mb-2">Tarikh: <%= course.tarikh_mula %> &rarr; <%= course.tarikh_akhir %></p>
                 <.link navigate={~p"/senaraikursususer"} class="px-5 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">
                  Lihat Lagi
                 </.link>
              </div>
            </div>
          <% end %>
        </div>
      </section>

      <!-- Kursus Jangka Pendek -->
      <section>
        <h2 class="text-2xl font-semibold mb-4 text-black-500">Kursus Jangka Pendek</h2>
        <div class="grid md:grid-cols-4 gap-6">
          <%= for course <- @short_courses do %>
            <div class="bg-white shadow-lg rounded-2xl overflow-hidden border border-gray-200 hover:shadow-xl transition">
              <img src={course.gambar_kursus} alt={course.nama_kursus} class="w-full h-48 object-cover" />
              <div class="p-6">
                <h3 class="text-lg font-bold text-gray-900 mb-2"><%= course.nama_kursus %></h3>
                <div class="flex items-center gap-2 mb-2">
                  <img src={course.gambar_anjuran} alt={course.anjuran} class="h-8 w-8 rounded-full" />
                  <p class="text-sm text-gray-600">Tajaan: <%= course.anjuran %></p>
                </div>
                 <p class="text-xs text-gray-500 mb-1">Tempat: <%= course.tempat %></p>
                 <p class="text-xs text-gray-500 mb-2">Tarikh: <%= course.tarikh_mula %> &rarr; <%= course.tarikh_akhir %></p>
                  <.link navigate={~p"/senaraikursususer"} class="px-5 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">
                  Lihat Lagi
                 </.link>
              </div>
             </div>
            <% end %>
           </div>
         </section>
        </div>
       </div>
    """
  end
end

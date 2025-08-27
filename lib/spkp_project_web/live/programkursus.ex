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
    <div class="max-w-7xl mx-auto p-6">

      <h1 class="text-4xl font-bold mb-8 text-center text-gray-800">Program</h1>

      <!-- Kursus Jangka Panjang -->
      <section class="mb-12">
        <h2 class="text-2xl font-semibold mb-4 text-gray-700">Kursus Jangka Panjang</h2>
        <div class="grid md:grid-cols-2 gap-6">
          <%= for course <- @long_courses do %>
            <div class="bg-white shadow-lg rounded-2xl overflow-hidden border border-gray-200 hover:shadow-xl transition">
              <img src={course.gambar_kursus} alt={course.nama_kursus} class="w-full h-48 object-cover" />
              <div class="p-6">
                <h3 class="text-lg font-bold text-gray-900 mb-2"><%= course.nama_kursus %></h3>
                <div class="flex items-center gap-2 mb-2">
                  <img src={course.gambar_anjuran} alt={course.anjuran} class="h-8 w-8 rounded-full" />
                  <p class="text-sm text-gray-600">Anjuran: <%= course.anjuran %></p>
                </div>
                <p class="text-xs text-gray-500 mb-1">Tempat: <%= course.tempat %></p>
                <p class="text-xs text-gray-500 mb-2">Tarikh: <%= course.tarikh_mula %> &rarr; <%= course.tarikh_akhir %></p>
                <.link navigate={~p"/senaraikursus"} class="px-5 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">
                  Lihat Lagi
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
            <div class="bg-white shadow-lg rounded-2xl overflow-hidden border border-gray-200 hover:shadow-xl transition">
              <img src={course.gambar_kursus} alt={course.nama_kursus} class="w-full h-48 object-cover" />
              <div class="p-6">
                <h3 class="text-lg font-bold text-gray-900 mb-2"><%= course.nama_kursus %></h3>
                <div class="flex items-center gap-2 mb-2">
                  <img src={course.gambar_anjuran} alt={course.anjuran} class="h-8 w-8 rounded-full" />
                  <p class="text-sm text-gray-600">Anjuran: <%= course.anjuran %></p>
                </div>
                <p class="text-xs text-gray-500 mb-1">Tempat: <%= course.tempat %></p>
                <p class="text-xs text-gray-500 mb-2">Tarikh: <%= course.tarikh_mula %> &rarr; <%= course.tarikh_akhir %></p>
                <.link navigate={~p"/senaraikursus"} class="px-5 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">
                  Lihat Lagi
                </.link>
              </div>
            </div>
          <% end %>
        </div>
      </section>

    </div>
    """
  end
end

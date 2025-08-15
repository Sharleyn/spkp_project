defmodule SpkpProjectWeb.LamanUtamaLive do
  use SpkpProjectWeb, :live_view

  # Data slider
  @slides [
    %{type: :image, src: "/images/logo 1.png"},
    %{type: :text, title: "VISI", body: "Menjadi sebuah organisasi terunggul dan bestari dalam menawarkan perkhidmatan di Negeri Sabah yang dikendalikan sepenuhnya oleh anak muda."},
    %{type: :list, title: "MISI", items: [
      "Menjadi penyedia khidmat yang terbaik dan disenangi oleh pelanggan",
      "Menawarkan khidmat yang mudah dan sistem birokrasi yang ceria pengguna",
      "Melestarikan masyarakat akar umbi dengan sikap 'murah hati dan pemberi'",
      "Mencontohi dan mengamalkan nilai-nilai murni dalam sebarang urusan",
      "Menitikberatkan kebajikan pekerja dan pelanggan dengan baik"
    ]}
  ]

  # Data galeri
  @gallery [
    "/images/1.jpg",
    "/images/2.jpg",
    "/images/3.jpg",
    "/images/4.jpg",
    "/images/5.jpg",
    "/images/6.jpeg",
    "/images/7.jpeg",
    "/images/8.jpg"
  ]

  def mount(_params, _session, socket) do
    if connected?(socket) do
      schedule_gallery_slide()
    end

    {:ok,
     socket
     |> assign(:slides, @slides)
     |> assign(:current_index, 0)
     |> assign(:gallery, @gallery)
     |> assign(:gallery_index, 0)}
  end

  # Manual slider utama
  def handle_event("goto_slide", %{"index" => idx}, socket) do
    {:noreply, assign(socket, :current_index, String.to_integer(idx))}
  end

  def handle_event("next_slide", _params, socket) do
    new_index = rem(socket.assigns.current_index + 1, length(socket.assigns.slides))
    {:noreply, assign(socket, :current_index, new_index)}
  end

  def handle_event("prev_slide", _params, socket) do
    new_index = rem(socket.assigns.current_index - 1 + length(socket.assigns.slides), length(socket.assigns.slides))
    {:noreply, assign(socket, :current_index, new_index)}
  end

  # Auto-slide galeri
  def handle_info(:next_gallery, socket) do
    schedule_gallery_slide()
    total = gallery_total(socket)
    new_index = rem(socket.assigns.gallery_index + 1, total)
    {:noreply, assign(socket, :gallery_index, new_index)}
  end

  defp schedule_gallery_slide() do
    Process.send_after(self(), :next_gallery, 3000) # tukar setiap 3s
  end

  defp gallery_total(socket) do
    socket.assigns.gallery
    |> Enum.chunk_every(4)
    |> length()
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
          <a href={~p"/program"} class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded">Program</a>
          <a href="/#hubungi" class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded">Hubungi</a>
        </div>
      </div>

      <!-- Slider -->
         <section class="max-w-6xl mx-auto mt-10 px-6 text-center">
            <div class="h-[320px] flex items-center justify-center">
                <%= if slide = Enum.at(@slides, @current_index) do %>
                <%= render_slide(%{slide: slide}) %>
                <% end %>
            </div>

            <div class="flex justify-center space-x-2 mt-4">
                <%= for i <- 0..(length(@slides) - 1) do %>
              <button
                phx-click="goto_slide"
                phx-value-index={i}
                class={if i == @current_index, do: "bg-blue-500 w-3 h-3 rounded-full", else: "bg-gray-300 w-3 h-3 rounded-full"}>
             </button>
           <% end %>
          </div>
         </section>
         </div>


      <!-- Kursus Ditawarkan -->
          <section class="transparent">
              <div class="max-w-7xl mx-auto mt-10 px-4">
                  <h2 class="bg-[#09033F] text-xl text-white font-bold text-center px-6 py-2  mb-6">KURSUS DITAWARKAN</h2>
                     <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                     <div class="bg-sky-300 bg-opacity-25 rounded-lg p-6">
                  <h3 class="font-semibold mb-4">Kursus Jangka Panjang</h3>
                     <ul class="list-disc list-inside space-y-1">
                     <li>Kursus Teknologi Maklumat - Program Software Development Bootcamp</li>
                     <li>Kursus Kecantikan Spa & Posnatal</li>
                    <li> </li>
                 </ul>
                 <img src={~p"/images/pic-panjang.jpeg"} alt="Kursus Panjang" class="mt-4 rounded-lg px-2 py-2 w-48 h-auto">
              </div>
              <div class="bg-sky-300 bg-opacity-25 rounded-lg p-6">
                 <h3 class="font-semibold mb-4">Kursus Jangka Pendek</h3>
                 <ul class="list-disc list-inside space-y-1">
                     <li>Kursus Masakan Pelbagai Jenis Kek Kukus</li>
                     <li>Kursus Asas Pemasangan & Penyelenggaraan Paip</li>
                     <li>Kursus Asas Membaikpulih & Penyelenggaraan Penghawa Dingin</li>
                </ul>
                 <img src={~p"/images/pic-pendek.jpeg"} alt="Kursus Pendek" class="mt-4 rounded-lg px-2 py-2 w-48 h-auto">
                 </div>
                </div>
              </div>
          </section>

            <section class="transparent">
            <!-- Tajuk penuh lebar -->
               <div class="max-w-7xl mx-auto mt-10 px-4">
               <h4 class="bg-[#09033F] text-xl text-white font-bold text-center mt-10 px-2 py-2">
                 STATISTIK
               </h4>

               <!-- Kandungan statistik -->
                <div class="max-w-7xl mx-auto px-4 py-10">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 place-items-center text-center">
                <div>
                  <img src={~p"/images/icon pelatih.png"} alt="Bilangan Pelatih" class="h-18 w-18 mb-2 mx-auto">
                  <div class="text-4xl font-bold">250</div>
                  <div class="text-gray-600">Bilangan Pelatih</div>
                </div>
              <div>
                  <img src={~p"/images/icon program.png"} alt="Bilangan Program" class="h-18 w-18 mb-2 mx-auto">
                  <div class="text-4xl font-bold">25</div>
                  <div class="text-gray-600">Bilangan Program</div>
              </div>
            <div>
                  <img src={~p"/images/icon jurusan.png"} alt="Jurusan Ditawarkan" class="h-18 w-18 mb-2 mx-auto">
                <div class="text-4xl font-bold">10</div>
                <div class="text-gray-600">Jurusan Ditawarkan</div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Galeri Auto-Slider -->
      <section class="max-w-7xl mx-auto px-4 mt-10">
        <h5 class="bg-[#09033F] text-xl text-white font-bold text-center px-6 py-2 mb-6">GALERI</h5>

        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 transition-all duration-500">
          <%= for img <- Enum.at(Enum.chunk_every(@gallery, 4), @gallery_index) || [] do %>
            <img src={img} alt="Galeri" class="rounded-lg shadow"/>
          <% end %>
        </div>
      </section>

      <!-- Footer -->
       <section id="hubungi">
           <footer class="bg-[#09033F] text-white mt-10 py-2 text-center">
             <p class="text-sm font-bold">SHARIF PERCHAYA SDN. BHD.</p>

           <div class="bg-[#09033F] text-white px-16 py-2 space-y-3 mx-auto text-left">
           <div class="flex items-center justify-between gap-6">


          <!-- Alamat -->
            <div class="flex items-center gap-4">
            <img src={~p"/images/office.png"} alt="Alamat" class="h-6 w-6">
            <p class="text-sm">Alamat: Block G. 2ND Floor, Lot 9, Lintas Jaya Uptownship Penampang, 88200 Sabah</p>
            </div>

            <!-- Telefon & Faks -->
              <div class="flex items-center gap-4">
              <img src={~p"/images/fax.png"} alt="Telefon & Faks" class="h-6 w-6">
              <p class="text-sm">No. Tel: 011-3371 7129<br>Faks: 088 729717</p>
            </div>

            <!-- Email -->
              <div class="flex items-center gap-4">
              <img src={~p"/images/email.png"} alt="Email" class="h-6 w-6">
              <p class="text-sm">Email: sharifperchaya@gmail.com</p>
              </div>

              <!-- FB -->
                <div class="flex items-center gap-4">
                <img src={~p"/images/fb.png"} alt="Facebook" class="h-6 w-6">
                <p class="text-sm">Sharif Perchaya Sdn Bhd</p>
                </div>
          </div>

              <!-- Waktu Operasi -->
                <p class="text-sm text-center font-bold">MASA OPERASI</p>
                <div class="bg-[#09033F] flex items-star text-white max-w-xl mx-auto mt-4 text-left gap-2">
                <img src={~p"/images/clock.png"} alt="Waktu Operasi" class="h-6 w-6">
                <p class="text-sm">
                Hari Bekerja: Isnin - Jumaat | 8:00 A.M. – 5:00 P.M. | Cuti: Sabtu, Ahad, Cuti Umum
                </p>
                 </div>
              </div>
          </footer>
        </section>

    """
  end

  defp render_slide(assigns) do    # <!-- Slider untuk LOGO, VISI, MISI -->
    ~H"""
    <div class="w-full h-[320px] flex items-center justify-center bg-white bg-opacity-50 rounded-lg p-6">
    <%= case @slide do %>
      <% %{type: :image, src: src} -> %>
        <img src={src} alt="logo" class="max-h-full max-w-full object-contain" />

      <% %{type: :text, title: title, body: body} -> %>
        <div class="flex flex-col justify-center text-center w-full h-full">
          <h2 class="text-xl font-bold mb-4"><%= title %></h2>
          <p class="mx-auto max-w-xl"><%= body %></p>
        </div>

      <% %{type: :list, title: title, items: items} -> %>
        <div class="flex flex-col justify-center w-full h-full">
          <h2 class="text-xl font-bold mb-4 text-center"><%= title %></h2>
          <ul class="list-disc list-inside space-y-1 text-left mx-auto max-w-xl">
            <%= for item <- items do %>
              <li><%= item %></li>
            <% end %>
          </ul>
        </div>
    <% end %>
    </div>
    """
  end
end

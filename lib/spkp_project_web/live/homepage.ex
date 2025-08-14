defmodule SpkpProjectWeb.HomeLive do
  use SpkpProjectWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
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
          <!-- Logo kiri -->
          <div class="flex items-center">
            <!-- Logo 1 -->
            <img src={~p"/images/logo 1.png"} alt="Logo 1" style="height:90px;" class="mr-6">

            <!-- Logo 2–6 rapat -->
            <div class="flex gap-1 mt-10">
              <img src={~p"/images/logo 2.png"} alt="Logo 2" class="h-10">
              <img src={~p"/images/logo 3.png"} alt="Logo 3" class="h-10">
              <img src={~p"/images/logo 4.png"} alt="Logo 4" class="h-10">
              <img src={~p"/images/logo 5.png"} alt="Logo 5" class="h-10">
              <img src={~p"/images/logo 6.png"} alt="Logo 6" class="h-16">
            </div>
          </div>

          <!-- Ikon kanan -->
          <div class="flex space-x-6">
            <!-- Pengguna -->
            <.link navigate={~p"/users/log_in"} class="flex flex-col items-center text-sm hover:opacity-80">
              <img src={~p"/images/orang awam.png"} alt="Pengguna" class="h-8 w-8 mb-1">
              <span>Pengguna</span>
            </.link>

            <!-- Admin -->
            <.link navigate={~p"/users/log_in"} class="flex flex-col items-center text-sm hover:opacity-80">
              <img src={~p"/images/admin.png"} alt="Admin" class="h-8 w-8 mb-1">
              <span>Admin</span>
            </.link>
          </div>
        </div>
      </header>

      <!-- Bar navigasi -->
      <div class="bg-[#09033F] shadow py-2">
        <div class="max-w-7xl mx-auto flex space-x-2">
          <a href={~p"/"} class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded">
            Laman Utama
          </a>
          <a href={~p"/mengenaikami"} class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded">
            Mengenai Kami
          </a>
          <a href={~p"/program"} class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded">
            Program
          </a>
          <a href="/#hubungi" class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded">
            Hubungi
          </a>
        </div>
      </div>

      <!-- Tambah CSS Swiper -->
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />

      <!-- Swiper Section -->
      <section class="transparent">
        <div class="max-w-6xl mx-auto mt-10 px-6">
          <div class="swiper vm-swiper relative group">
            <div class="swiper-wrapper">
              <!-- Slide 1 -->
              <div class="swiper-slide flex justify-center items-center">
                <img src={~p"/images/logo 1.png"} alt="logo" class="w-100 h-80 mx-auto rounded-lg">
              </div>

              <!-- Slide 2 - Visi -->
              <div class="swiper-slide">
                <div class="bg-white bg-opacity-50 rounded-lg p-20">
                  <h2 class="text-center text-xl font-bold mb-12">VISI</h2>
                  <p>
                    Menjadi sebuah organisasi terunggul dan bestari dalam menawarkan perkhidmatan di Negeri Sabah yang dikendalikan sepenuhnya oleh anak muda.
                  </p>
                </div>
              </div>

              <!-- Slide 3 - Misi -->
              <div class="swiper-slide">
                <div class="bg-white bg-opacity-50 rounded-lg p-14">
                  <h2 class="text-center text-xl font-bold mb-12">MISI</h2>
                  <ul class="list-disc list-inside space-y-1">
                    <li>Menjadi penyedia khidmat yang terbaik dan disenangi oleh pelanggan</li>
                    <li>Menawarkan khidmat yang mudah dan sistem birokrasi yang ceria pengguna</li>
                    <li>Melestarikan masyarakat akar umbi dengan sikap “murah hati dan pemberi”</li>
                    <li>Mencontohi dan mengamalkan nilai-nilai murni dalam sebarang urusan</li>
                    <li>Menitikberatkan kebajikan pekerja dan pelanggan dengan baik</li>
                  </ul>
                </div>
              </div>
            </div>

            <!-- Navigation -->
            <div class="swiper-button-next vm-next"></div>
            <div class="swiper-button-prev vm-prev"></div>

            <!-- Pagination -->
            <div class="swiper-pagination vm-pagination"></div>
          </div>
        </div>
      </section>

      <style>
        .vm-swiper .vm-next,
        .vm-swiper .vm-prev {
          width: 32px;
          height: 32px;
          background-color: rgba(0, 0, 0, 0.5);
          border-radius: 50%;
          transition: opacity 0.3s ease;
          opacity: 0;
        }

        .vm-swiper .vm-next::after,
        .vm-swiper .vm-prev::after {
          font-size: 14px;
          color: white;
        }

        .vm-swiper.group:hover .vm-next,
        .vm-swiper.group:hover .vm-prev {
          opacity: 1;
        }
      </style>

      <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
      <script>
        var swiperVM = new Swiper(".vm-swiper", {
          loop: true,
          autoplay: {
            delay: 3000,
            disableOnInteraction: false,
          },
          navigation: {
            nextEl: ".vm-next",
            prevEl: ".vm-prev",
          },
          pagination: {
            el: ".vm-pagination",
            clickable: true,
          },
        });
      </script>

      <!-- Kursus Ditawarkan -->
      ...
      <!-- (Bahagian seterusnya saya kekalkan tapi rapi sama macam di atas) -->
      ...
    </div>
    """
  end
end

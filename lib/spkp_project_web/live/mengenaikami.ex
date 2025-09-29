defmodule SpkpProjectWeb.MengenaiKamiLive do
  use SpkpProjectWeb, :live_view

  # ⬅️ tambah ini
  import SpkpProjectWeb.MengenaiKamiHTML

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
    <div id="app" class="flex flex-col min-h-screen font-sans">
      <!-- Header -->
      <header class="transparent">
        <div class="max-w-7xl mx-auto flex items-center justify-between px-4 py-3">
          <!-- Logo kiri -->
          <div class="flex items-center">
            <!-- Logo 1 -->
            <img src={~p"/images/logo 1.png"} alt="Logo 1" style="height:90px;" class="mr-6" />
            <!-- Logo 2–6 rapat -->
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
              <img src={~p"/images/orang awam.png"} alt="Pengguna" class="h-8 w-10 mb-1" />
              <span>Pengguna</span>
            </.link>

            <!-- Admin -->
            <.link
              navigate={~p"/users/log_in"}
              class="flex flex-col items-center text-sm hover:opacity-80"
            >
              <img src={~p"/images/admin.png"} alt="Admin" class="h-8 w-10 mb-1" /> <span>Admin</span>
            </.link>

            <!-- Pekerja -->
            <.link href={~p"/users/log_in"} class="flex flex-col items-center text-sm hover:opacity-80">
                <img src={~p"/images/user.png"} alt="Pekerja" class="h-8 w-6 mb-1" />
                  <span>Pekerja</span>
             </.link>

          </div>
        </div>
      </header>

      <!-- Table menu bawah header -->
      <!-- Bar navigasi -->
      <div class="bg-[#09033F] shadow py-2">
        <div class="max-w-7xl mx-auto flex space-x-2">
          <a
            href={~p"/"}
            class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded"
          >
            Halaman Utama
          </a>
          <a
            href={~p"/mengenaikami"}
            class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded"
          >
            Mengenai Kami
          </a>
          <a
            href={~p"/programkursus"}
            class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded"
          >
            Program
          </a>
          <a
            href="/#hubungi"
            class="px-1 py-1 bg-[#09033F] text-white font-medium hover:bg-[#1a155f] rounded"
          >
            Hubungi
          </a>
        </div>
      </div>

      <div class="max-w-6xl mx-auto px-4 py-8">
        <!-- Navigation Tabs -->
        <div class="flex flex-wrap border-b border-gray-300 mb-6">
          <button
            class="tab-link active px-4 py-2 text-base font-semibold text-gray-700 hover:text-[#09033F]"
            data-tab="latar"
          >
            Latar Belakang
          </button>
          <button
            class="tab-link px-4 py-2 text-base font-semibold text-gray-700 hover:text-[#09033F]"
            data-tab="carta"
          >
            Carta Organisasi
          </button>
          <button
            class="tab-link px-4 py-2 text-base font-semibold text-gray-700 hover:text-[#09033F]"
            data-tab="visi"
          >
            Visi & Misi
          </button>
          <button
            class="tab-link px-4 py-2 text-base font-semibold text-gray-700 hover:text-[#09033F]"
            data-tab="objektif"
          >
            Objektif
          </button>
        </div>

        <!-- Tab Content -->
        <!-- LATAR BELAKANG -->
        <div id="latar" class="tab-content mx-auto mt-8">
          <.latar_belakang />
        </div>

        <!-- CARTA ORGANISASI -->
        <div id="carta" class="tab-content hidden">
          <h2 class="text-2xl flex justify-center font-bold mb-4">Carta Organisasi</h2>
          <img src={~p"/images/organisasi.png"} alt="Carta Organisasi" class="flex justify-center w-full">
        </div>

        <!-- VISI -->
        <div id="visi" class="tab-content hidden">
          <div class="bg-sky-50 rounded-lg p-20 mb-6">
            <h3 class="text-center text-xl font-bold mb-12">VISI</h3>
            <p>
              Menjadi sebuah organisasi terunggul dan bestari dalam menawarkan perkhidmatan di Negeri Sabah yang dikendalikan sepenuhnya oleh anak muda.
            </p>
          </div>

          <!-- MISI -->
          <div class="bg-sky-50 rounded-lg p-14">
            <h3 class="text-center text-xl font-bold mb-12">MISI</h3>
            <ul class="list-disc list-inside space-y-1">
              <li>Menjadi penyedia khidmat yang terbaik dan disenangi oleh pelanggan</li>

              <li>Menawarkan khidmat yang mudah dan sistem birokrasi yang ceria pengguna</li>

              <li>Melestarikan masyarakat akar umbi dengan sikap “murah hati dan pemberi”</li>

              <li>Mencontohi dan mengamalkan nilai-nilai murni dalam sebarang urusan</li>

              <li>Menitikberatkan kebajikan pekerja dan pelanggan dengan baik</li>
            </ul>
          </div>
        </div>

        <!-- OBJEKTIF -->
        <div id="objektif" class="tab-content hidden">
          <h2 class="text-2xl font-bold mb-4">Objektif</h2>
          <ul class="list-disc list-inside space-y-1">
            <li>Memberi perkhidmatan berkualiti tinggi dalam setiap bidang operasi syarikat demi memenuhi keperluan pelanggan.</li>

            <li>Membina hubungan yang berkekalan dan dipercayai dengan pelanggan, rakan kongsi, serta komuniti setempat.</li>

            <li>Mengembangkan perniagaan secara mampan dengan mengutamakan inovasi, keberkesanan kos, dan kepuasan pelanggan.</li>

            <li>Melahirkan peluang pekerjaan dan membangunkan bakat anak muda tempatan khususnya di Sabah.</li>

            <li>Menyumbang kepada pembangunan masyarakat melalui aktiviti korporat yang berteraskan nilai keprihatinan dan tanggungjawab sosial.</li>
          </ul>
        </div>

        <!-- CSS untuk Tab -->
        <style>
          .tab-link {
            border-bottom: 2px solid transparent;
          }
          .tab-link.active {
            border-bottom-color: #09033F;
            color: #09033F;
          }
        </style>

        <!-- JS untuk Tukar Paparan -->
        <script>
          document.addEventListener("DOMContentLoaded", function () {
            document.querySelectorAll(".tab-link").forEach(button => {
              button.addEventListener("click", () => {
                const tabID = button.getAttribute("data-tab");

                // Buang 'active' dari semua butang
                document.querySelectorAll(".tab-link").forEach(btn => btn.classList.remove("active"));
                // Sembunyikan semua tab content
                document.querySelectorAll(".tab-content").forEach(content => content.classList.add("hidden"));

                // Aktifkan butang yang diklik
                button.classList.add("active");
                // Paparkan tab content yang dipilih
                document.getElementById(tabID).classList.remove("hidden");
              });
            });
          });
        </script>
      </div>

      <!-- Footer -->
      <footer class="bg-[#09033F] text-white py-2 mt-auto text-center">
        <p class="text-sm font-bold">SHARIF PERCHAYA SDN. BHD.</p>
        <div class="bg-[#09033F] text-white px-16 py-2 space-y-3 mx-auto text-left">
          <div class="flex items-center justify-between gap-6">
            <div class="flex items-center gap-4">
              <img src={~p"/images/office.png"} alt="Alamat" class="h-6 w-6" />
              <p class="text-sm">Alamat: Block G. 2ND Floor, Lot 9, Lintas Jaya Uptownship Penampang, 88200 Sabah</p>
            </div>
            <div class="flex items-center gap-4">
              <img src={~p"/images/fax.png"} alt="Telefon & Faks" class="h-6 w-6" />
              <p class="text-sm">No. Tel: 011-3371 7129<br /> Faks: 088 729717</p>
            </div>
            <div class="flex items-center gap-4">
              <img src={~p"/images/email.png"} alt="Email" class="h-6 w-6" />
              <p class="text-sm">Email: sharifperchaya@gmail.com</p>
            </div>
            <div class="flex items-center gap-4">
              <img src={~p"/images/fb.png"} alt="Facebook" class="h-6 w-6" />
              <p class="text-sm">Sharif Perchaya Sdn Bhd</p>
            </div>
          </div>
          <p class="text-sm text-center font-bold">MASA OPERASI</p>
          <div class="bg-[#09033F] flex items-star text-white max-w-xl mx-auto mt-4 text-left gap-2">
            <img src={~p"/images/clock.png"} alt="Waktu Operasi" class="h-6 w-6" />
            <p class="text-sm">Hari Bekerja: Isnin - Jumaat | 8:00 A.M. – 5:00 P.M. | Cuti: Sabtu, Ahad, Cuti Umum</p>
          </div>
        </div>
      </footer>

      <!-- Tab Script -->
      <script>
        document.addEventListener("DOMContentLoaded", function () {
          document.querySelectorAll(".tab-link").forEach(button => {
            button.addEventListener("click", () => {
              const tabID = button.getAttribute("data-tab");
              document.querySelectorAll(".tab-link").forEach(btn => btn.classList.remove("active"));
              document.querySelectorAll(".tab-content").forEach(content => content.classList.add("hidden"));
              button.classList.add("active");
              document.getElementById(tabID).classList.remove("hidden");
            });
          });
        });
      </script>

    </div>
    </div>
    """
  end
end

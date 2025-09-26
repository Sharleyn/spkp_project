defmodule SpkpProject.Email do
  import Swoosh.Email

  # ================================
  #  PERMOHONAN DITOLAK
  # ================================
  def permohonan_ditolak(permohonan) do
    new()
    |> to(permohonan.user.email)
    |> from({"SPKP", "noreply@spkp.com"})
    |> subject("Permohonan Kursus Ditolak")
    |> text_body("""
    Assalamualaikum/Salam Sejahtera #{permohonan.user.full_name},

    Kami ingin memaklumkan bahawa permohonan anda untuk menyertai kursus:

    Nama Kursus : #{permohonan.kursus.nama_kursus}
    Tempat      : #{permohonan.kursus.tempat}
    Tarikh      : #{permohonan.kursus.tarikh_mula} - #{permohonan.kursus.tarikh_akhir}

    Status permohonan: DITOLAK

    Terima kasih kerana memohon. Anda boleh cuba memohon kursus lain pada masa akan datang.

    Sekian,
    SPKP
    """)
  end

  # ================================
  #  PERMOHONAN DITERIMA
  # ================================
  def permohonan_diterima(permohonan) do
    new()
    |> to(permohonan.user.email)
    |> from({"SPKP", "noreply@spkp.com"})
    |> subject("Permohonan Kursus Diterima")
    |> text_body("""
    Tahniah #{permohonan.user.full_name}!

    Permohonan anda untuk menyertai kursus:

    Nama Kursus : #{permohonan.kursus.nama_kursus}
    Tempat      : #{permohonan.kursus.tempat}
    Tarikh      : #{permohonan.kursus.tarikh_mula} - #{permohonan.kursus.tarikh_akhir}

    Telah DITERIMA.

    Sila hadir ke lokasi kursus pada tarikh yang ditetapkan. Maklumat lanjut akan diberikan kemudian.

    Sekian,
    SPKP
    """)
  end
end

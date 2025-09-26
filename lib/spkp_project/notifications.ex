defmodule SpkpProject.PermohonanNotifier do
  import Swoosh.Email

  alias SpkpProject.Mailer

  def status_email(user, permohonan) do
    new()
    |> to({user.name, user.email})
    |> from({"SPKP Sistem", "noreply@spkp.local"})
    |> subject("Status Permohonan Kursus Anda")
    |> html_body("""
    <h3>Hai #{user.name},</h3>
    <p>Status permohonan anda untuk kursus <b>#{permohonan.kursus.nama}</b> telah dikemaskini:</p>
    <p><b>Status:</b> #{permohonan.status}</p>
    <p>Terima kasih menggunakan SPKP.</p>
    """)
    |> text_body("""
    Hai #{user.name},

    Status permohonan anda untuk kursus #{permohonan.kursus.nama} telah dikemaskini.

    Status: #{permohonan.status}

    Terima kasih menggunakan SPKP.
    """)
  end

  def deliver_status_email(user, permohonan) do
    user
    |> status_email(permohonan)
    |> Mailer.deliver()
  end
end

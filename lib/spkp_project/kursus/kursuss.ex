defmodule SpkpProject.Kursus.Kursuss do
  use Ecto.Schema
  import Ecto.Changeset

  schema "kursus" do
    field :nama_kursus, :string
    field :tarikh_mula, :date
    field :tarikh_akhir, :date
    field :tempat, :string
    field :status_kursus, :string
    field :had_umur, :integer
    field :anjuran, :string
    field :gambar_anjuran, :string
    field :gambar_kursus, :string
    field :syarat_penyertaan, :string
    field :syarat_pendidikan, :string
    field :kuota, :integer
    field :tarikh_tutup, :date

    belongs_to :kursus_kategori, SpkpProject.Kursus.KursusKategori, foreign_key: :kursus_kategori_id


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(kursuss, attrs) do
    kursuss
    |> cast(attrs, [:nama_kursus, :tarikh_mula, :tarikh_akhir, :tempat, :status_kursus, :had_umur, :anjuran, :gambar_anjuran, :gambar_kursus, :syarat_penyertaan, :syarat_pendidikan, :kuota, :tarikh_tutup, :kursus_kategori_id])
    |> validate_required([:nama_kursus, :tarikh_mula, :tarikh_akhir, :tempat, :status_kursus, :had_umur, :anjuran, :gambar_anjuran, :gambar_kursus, :syarat_penyertaan, :syarat_pendidikan, :kuota, :tarikh_tutup, :kursus_kategori_id])
  end
end

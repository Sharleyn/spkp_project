defmodule SpkpProject.Repo.Migrations.CreateKursus do
  use Ecto.Migration

  def change do
    create table(:kursus) do
      add :nama_kursus, :string
      add :tarikh_mula, :date
      add :tarikh_akhir, :date
      add :tempat, :string
      add :status_kursus, :string
      add :had_umur, :integer
      add :anjuran, :string
      add :gambar_anjuran, :string
      add :gambar_kursus, :string
      add :syarat_penyertaan, :string
      add :syarat_pendidikan, :string
      add :kuota, :integer
      add :tarikh_tutup, :date
      add :kursus_kategori_id, references(:kursus_kategori, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:kursus, [:kursus_kategori_id])
  end
end

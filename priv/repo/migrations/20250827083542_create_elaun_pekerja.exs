defmodule SpkpProject.Repo.Migrations.CreateElaunPekerja do
  use Ecto.Migration

  def change do
    create table(:elaun_pekerja) do
      add :tarikh_mula, :date
      add :tarikh_akhir, :date
      add :status_permohonan, :string
      add :jumlah_keseluruhan, :decimal
      add :maklumat_pekerja_id, references(:maklumat_pekerja, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:elaun_pekerja, [:maklumat_pekerja_id])
  end
end

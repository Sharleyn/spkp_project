defmodule SpkpProject.Repo.Migrations.CreateItemElaunPekerja do
  use Ecto.Migration

  def change do
    create table(:item_elaun_pekerja) do
      add :kenyataan_tuntutan, :string
      add :tarikh_tuntutan, :date
      add :masa_mula, :time
      add :masa_tamat, :time
      add :keterangan, :string
      add :jumlah, :decimal
      add :elaun_pekerja_id, references(:elaun_pekerja, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:item_elaun_pekerja, [:elaun_pekerja_id])
  end
end

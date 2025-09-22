defmodule SpkpProject.Repo.Migrations.MoveNotaJadualToKursus do
  use Ecto.Migration

  def change do

    # 🟢 Tambah field dalam kursus
    alter table(:kursus) do
      add :nota_kursus, :string
      add :jadual_kursus, :string
    end

    # 🔴 Buang field dari userpermohonan
    alter table(:userpermohonan) do
      remove :nota_kursus
      remove :jadual_kursus
    end
  end
end

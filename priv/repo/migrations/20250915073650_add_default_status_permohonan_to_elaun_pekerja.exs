defmodule SpkpProject.Repo.Migrations.AddDefaultStatusPermohonanToElaunPekerja do
  use Ecto.Migration

  def change do
    alter table(:elaun_pekerja) do
      modify :status_permohonan, :string, default: "draft", null: false
    end
  end
end

defmodule SpkpProject.Repo.Migrations.ChangeSyaratPenyertaanToText do
  use Ecto.Migration

  def change do
    alter table(:kursus) do
      modify :syarat_penyertaan, :text
    end
  end
end

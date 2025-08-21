defmodule SpkpProject.Repo.Migrations.CreateKursusKategori do
  use Ecto.Migration

  def change do
    create table(:kursus_kategori) do
      add :kategori, :string

      timestamps(type: :utc_datetime)
    end
  end
end

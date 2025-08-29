defmodule SpkpProject.Repo.Migrations.AddKaedahToKursus do
  use Ecto.Migration

  def change do
    alter table(:kursus) do
      add :kaedah, :string
    end
  end
end

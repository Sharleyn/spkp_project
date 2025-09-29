defmodule SpkpProject.Repo.Migrations.AddResitToElaunPekerja do
  use Ecto.Migration

  def change do
    alter table(:elaun_pekerja) do
      add :resit, :string
    end
  end
end

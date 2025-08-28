defmodule SpkpProject.Repo.Migrations.CreateMaklumatPekerja do
  use Ecto.Migration

  def change do
    create table(:maklumat_pekerja) do
      add :no_ic, :string
      add :no_tel, :string
      add :nama_bank, :string
      add :no_akaun, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:maklumat_pekerja, [:user_id])
  end
end

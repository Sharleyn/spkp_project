defmodule SpkpProject.Repo.Migrations.CreateCertificates do
  use Ecto.Migration

  def change do
    create table(:certificates) do
      add :sijil_url, :string
      add :nama_sijil, :string
      add :issued_at, :date
      add :user_id, references(:users, on_delete: :nothing)
      add :kursus_id, references(:kursus, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:certificates, [:user_id])
    create index(:certificates, [:kursus_id])
  end
end

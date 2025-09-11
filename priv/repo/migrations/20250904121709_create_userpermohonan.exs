defmodule SpkpProject.Repo.Migrations.CreateUserpermohonan do
  use Ecto.Migration

  def change do
    create table(:userpermohonan) do
      add :status, :string, default: "dalam_proses"
      add :nota_kursus, :string
      add :jadual_kursus, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :kursus_id, references(:kursus, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:userpermohonan, [:user_id])
    create index(:userpermohonan, [:kursus_id])
  end
end

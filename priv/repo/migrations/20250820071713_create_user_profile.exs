defmodule SpkpProject.Repo.Migrations.CreateUserProfile do
  use Ecto.Migration

  def change do
    create table(:user_profiles) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :ic, :string
      add :age, :integer
      add :gender, :string
      add :phone_number, :string
      add :address, :string
      add :district, :string
      add :education, :string

      timestamps()
    end

    create unique_index(:user_profiles, [:user_id])
  end
end

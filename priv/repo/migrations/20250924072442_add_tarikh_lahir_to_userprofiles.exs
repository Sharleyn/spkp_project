defmodule SpkpProject.Repo.Migrations.AddTarikhLahirToUserprofiles do
  use Ecto.Migration

  def change do
    alter table(:user_profiles) do
      add :tarikh_lahir, :date
    end

  end
end

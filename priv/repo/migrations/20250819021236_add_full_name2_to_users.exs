defmodule SpkpProject.Repo.Migrations.AddFullName2ToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :full_name, :string
    end
  end
end

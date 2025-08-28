defmodule SpkpProject.Repo.Migrations.AddIcAttachmentToUserProfiles do
  use Ecto.Migration

  def change do
      alter table(:user_profiles) do
      add :ic_attachment, :string
    end
  end
end

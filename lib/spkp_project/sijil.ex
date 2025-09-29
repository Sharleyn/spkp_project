defmodule SpkpProject.Sijil do
  import Ecto.Query, warn: false
  alias SpkpProject.{Repo, Certificate} # schema kamu masih guna nama Certificate

  # Senarai sijil ikut user_permohonan
  def list_sijil(user_permohonan_id) do
    from(c in Certificate, where: c.user_permohonan_id == ^user_permohonan_id)
    |> Repo.all()
  end

  # Dapatkan satu sijil
  def get_sijil!(id) do
    Repo.get!(Certificate, id) |> Repo.preload([:user, :kursus])
  end

  # Buat sijil baru
  def create_sijil(attrs \\ %{}) do
    %Certificate{}
    |> Certificate.changeset(attrs)
    |> Repo.insert()
  end

  # Update sijil
  def update_sijil(%Certificate{} = sijil, attrs) do
    sijil
    |> Certificate.changeset(attrs)
    |> Repo.update()
  end

  # Delete sijil
  def delete_sijil(%Certificate{} = sijil) do
    Repo.delete(sijil)
  end
end

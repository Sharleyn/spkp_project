defmodule SpkpProject.Certificate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "certificates" do
    field :sijil_url, :string
    field :nama_sijil, :string
    field :issued_at, :date

    belongs_to :user, SpkpProject.Accounts.User
    belongs_to :kursus, SpkpProject.Kursus.Kursuss
    belongs_to :user_permohonan, SpkpProject.Userpermohonan.Userpermohonan

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(certificate, attrs) do
    certificate
    |> cast(attrs, [:sijil_url, :nama_sijil, :issued_at, :user_id, :kursus_id])
    |> validate_required([:sijil_url, :nama_sijil, :issued_at, :user_id, :kursus_id])
  end
end

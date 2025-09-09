defmodule SpkpProject.Userpermohonan.Userpermohonan do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias SpkpProject.Repo
  alias SpkpProject.Kursus.Kursuss
  alias SpkpProject.Accounts.User

  schema "userpermohonan" do
    field :status, :string, default: "Dalam Proses"
    field :nota_kursus, :string
    field :jadual_kursus, :string

    belongs_to :user, SpkpProject.Accounts.User
    belongs_to :kursus, SpkpProject.Kursus.Kursuss

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(userpermohonan, attrs) do
    userpermohonan
    |> cast(attrs, [:user_id, :kursus_id, :status, :nota_kursus, :jadual_kursus])
    |> validate_required([:user_id, :kursus_id, :status])
  end

   # -------- CREATE PERMOHONAN --------
   def create_application(user_id, kursus_id) do
    %__MODULE__{}   # ✅ betul
    |> changeset(%{user_id: user_id, kursus_id: kursus_id, status: "Dalam Proses"})
    |> Repo.insert()
  end

  # -------- LIST PERMOHONAN --------
  def list_user_applications(user_id, filter \\ "Semua Keputusan") do
    query =
      from(p in Userpermohonan,
        where: p.user_id == ^user_id,
        join: k in assoc(p, :kursus),
        preload: [kursus: k],
        order_by: [desc: p.inserted_at]
      )

    case filter do
      "Diterima" -> query |> where([p], p.status == "Diterima") |> Repo.all()
      "Dalam Proses" -> query |> where([p], p.status == "Dalam Proses") |> Repo.all()
      "Ditolak" -> query |> where([p], p.status == "Ditolak") |> Repo.all()
      _ -> Repo.all(query)
    end
  end

end

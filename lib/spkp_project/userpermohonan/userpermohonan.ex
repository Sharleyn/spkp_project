defmodule SpkpProject.Userpermohonan.Userpermohonan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "userpermohonan" do
    field :status, :string
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
end

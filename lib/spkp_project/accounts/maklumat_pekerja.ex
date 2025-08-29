defmodule SpkpProject.Accounts.MaklumatPekerja do
  use Ecto.Schema
  import Ecto.Changeset

  schema "maklumat_pekerja" do
    field :no_ic, :string
    field :no_tel, :string
    field :nama_bank, :string
    field :no_akaun, :string

    belongs_to :user, SpkpProject.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(maklumat_pekerja, attrs) do
    maklumat_pekerja
    |> cast(attrs, [:no_ic, :no_tel, :nama_bank, :no_akaun, :user_id])
    |> validate_required([:no_ic, :no_tel, :nama_bank, :no_akaun, :user_id])
  end
end

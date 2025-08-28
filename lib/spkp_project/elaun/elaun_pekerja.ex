defmodule SpkpProject.Elaun.ElaunPekerja do
  use Ecto.Schema
  import Ecto.Changeset

  schema "elaun_pekerja" do
    field :tarikh_mula, :date
    field :tarikh_akhir, :date
    field :status_permohonan, :string
    field :jumlah_keseluruhan, :decimal

    belongs_to :maklumat_pekerja, SpkpProject.Accounts.MaklumatPekerja

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(elaun_pekerja, attrs) do
    elaun_pekerja
    |> cast(attrs, [:tarikh_mula, :tarikh_akhir, :status_permohonan, :jumlah_keseluruhan, :maklumat_pekerja_id])
    |> validate_required([:tarikh_mula, :tarikh_akhir, :status_permohonan, :jumlah_keseluruhan, :maklumat_pekerja_id])
  end
end

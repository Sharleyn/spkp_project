defmodule SpkpProject.Elaun.ElaunPekerja do
  use Ecto.Schema
  import Ecto.Changeset

  schema "elaun_pekerja" do
    field :tarikh_mula, :date
    field :tarikh_akhir, :date
    field :status_permohonan, :string, default: "draft"
    field :jumlah_keseluruhan, :decimal
    field :resit, :string

    belongs_to :maklumat_pekerja, SpkpProject.Accounts.MaklumatPekerja
        # ✅ Hubungan dengan item tuntutan
    has_many :item_elaun_pekerja, SpkpProject.Elaun.ItemElaunPekerja,
    foreign_key: :elaun_pekerja_id,
    on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(elaun_pekerja, attrs) do
    elaun_pekerja
    |> cast(attrs, [:tarikh_mula, :tarikh_akhir, :status_permohonan, :jumlah_keseluruhan, :maklumat_pekerja_id, :resit])
    |> validate_required([:tarikh_mula, :tarikh_akhir, :status_permohonan, :jumlah_keseluruhan, :maklumat_pekerja_id])
  end

  def human_status_permohonan(status_permohonan) do
    case String.downcase(status_permohonan) do
      "draft" -> "Draft"
      "submitted" -> "Menunggu Kelulusan"
      "diterima" -> "Diterima"
      "ditolak" -> "Ditolak"
      _ -> status_permohonan
    end
  end
end

defmodule SpkpProject.Elaun.ItemElaunPekerja do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item_elaun_pekerja" do
    field :kenyataan_tuntutan, :string
    field :tarikh_tuntutan, :date
    field :masa_mula, :time
    field :masa_tamat, :time
    field :keterangan, :string
    field :jumlah, :decimal

    belongs_to :elaun_pekerja, SpkpProject.Elaun.ElaunPekerja

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item_elaun_pekerja, attrs) do
    item_elaun_pekerja
    |> cast(attrs, [:kenyataan_tuntutan, :tarikh_tuntutan, :masa_mula, :masa_tamat, :keterangan, :jumlah, :elaun_pekerja_id])
    |> validate_required([:kenyataan_tuntutan, :tarikh_tuntutan, :masa_mula, :masa_tamat, :keterangan, :jumlah, :elaun_pekerja_id])
  end
end

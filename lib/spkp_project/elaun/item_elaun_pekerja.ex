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
    |> cast(attrs, [:kenyataan_tuntutan, :tarikh_tuntutan, :masa_mula, :masa_tamat, :keterangan, :elaun_pekerja_id])
    |> validate_required([:kenyataan_tuntutan, :tarikh_tuntutan, :masa_mula, :masa_tamat, :keterangan, :elaun_pekerja_id])
    |> validate_tarikh_dalam_range()
    |> calculate_jumlah()   # ✅ Tambah auto-kira jumlah
  end

  defp validate_tarikh_dalam_range(changeset) do
    case {get_field(changeset, :elaun_pekerja_id), get_field(changeset, :tarikh_tuntutan)} do
      {nil, _} ->
        changeset

      {_, nil} ->
        changeset

      {elaun_id, tarikh_tuntutan} ->
        elaun = SpkpProject.Elaun.get_elaun_pekerja!(elaun_id)

        if Date.compare(tarikh_tuntutan, elaun.tarikh_mula) != :lt and
           Date.compare(tarikh_tuntutan, elaun.tarikh_akhir) != :gt do
          changeset
        else
          add_error(
            changeset,
            :tarikh_tuntutan,
            "Tarikh mesti dalam julat elaun (#{elaun.tarikh_mula} - #{elaun.tarikh_akhir})"
          )
        end
    end
end

   # ✅ Auto-kira jumlah ikut beza masa × 8.72
   defp calculate_jumlah(changeset) do
    case {get_field(changeset, :masa_mula), get_field(changeset, :masa_tamat)} do
      {nil, _} -> changeset
      {_, nil} -> changeset
      {masa_mula, masa_tamat} ->
        diff_seconds = Time.diff(masa_tamat, masa_mula, :second)

        if diff_seconds > 0 do
          hours =
            diff_seconds
            |> Decimal.new()
            |> Decimal.div(3600)

          rate = Decimal.new("8.72")
          jumlah = Decimal.mult(hours, rate)

          put_change(changeset, :jumlah, jumlah)
        else
          add_error(changeset, :masa_tamat, "Masa tamat mesti selepas masa mula")
        end
    end
  end
end

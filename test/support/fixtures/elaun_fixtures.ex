defmodule SpkpProject.ElaunFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SpkpProject.Elaun` context.
  """

  @doc """
  Generate a elaun_pekerja.
  """
  def elaun_pekerja_fixture(attrs \\ %{}) do
    {:ok, elaun_pekerja} =
      attrs
      |> Enum.into(%{
        jumlah_keseluruhan: "120.5",
        status_permohonan: "some status_permohonan",
        tarikh_akhir: ~D[2025-08-26],
        tarikh_mula: ~D[2025-08-26]
      })
      |> SpkpProject.Elaun.create_elaun_pekerja()

    elaun_pekerja
  end
end

defmodule SpkpProject.KursusFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SpkpProject.Kursus` context.
  """

  @doc """
  Generate a kursus_kategori.
  """
  def kursus_kategori_fixture(attrs \\ %{}) do
    {:ok, kursus_kategori} =
      attrs
      |> Enum.into(%{
        kategori: "some kategori"
      })
      |> SpkpProject.Kursus.create_kursus_kategori()

    kursus_kategori
  end

  @doc """
  Generate a kursuss.
  """
  def kursuss_fixture(attrs \\ %{}) do
    {:ok, kursuss} =
      attrs
      |> Enum.into(%{
        anjuran: "some anjuran",
        gambar_anjuran: "some gambar_anjuran",
        gambar_kursus: "some gambar_kursus",
        had_umur: 42,
        kuota: 42,
        nama_kursus: "some nama_kursus",
        status_kursus: "some status_kursus",
        syarat_pendidikan: "some syarat_pendidikan",
        syarat_penyertaan: "some syarat_penyertaan",
        tarikh_akhir: ~D[2025-08-20],
        tarikh_mula: ~D[2025-08-20],
        tarikh_tutup: ~D[2025-08-20],
        tempat: "some tempat"
      })
      |> SpkpProject.Kursus.create_kursuss()

    kursuss
  end
end

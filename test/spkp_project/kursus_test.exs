defmodule SpkpProject.KursusTest do
  use SpkpProject.DataCase

  alias SpkpProject.Kursus

  describe "kursus_kategori" do
    alias SpkpProject.Kursus.KursusKategori

    import SpkpProject.KursusFixtures

    @invalid_attrs %{kategori: nil}

    test "list_kursus_kategori/0 returns all kursus_kategori" do
      kursus_kategori = kursus_kategori_fixture()
      assert Kursus.list_kursus_kategori() == [kursus_kategori]
    end

    test "get_kursus_kategori!/1 returns the kursus_kategori with given id" do
      kursus_kategori = kursus_kategori_fixture()
      assert Kursus.get_kursus_kategori!(kursus_kategori.id) == kursus_kategori
    end

    test "create_kursus_kategori/1 with valid data creates a kursus_kategori" do
      valid_attrs = %{kategori: "some kategori"}

      assert {:ok, %KursusKategori{} = kursus_kategori} =
               Kursus.create_kursus_kategori(valid_attrs)

      assert kursus_kategori.kategori == "some kategori"
    end

    test "create_kursus_kategori/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Kursus.create_kursus_kategori(@invalid_attrs)
    end

    test "update_kursus_kategori/2 with valid data updates the kursus_kategori" do
      kursus_kategori = kursus_kategori_fixture()
      update_attrs = %{kategori: "some updated kategori"}

      assert {:ok, %KursusKategori{} = kursus_kategori} =
               Kursus.update_kursus_kategori(kursus_kategori, update_attrs)

      assert kursus_kategori.kategori == "some updated kategori"
    end

    test "update_kursus_kategori/2 with invalid data returns error changeset" do
      kursus_kategori = kursus_kategori_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Kursus.update_kursus_kategori(kursus_kategori, @invalid_attrs)

      assert kursus_kategori == Kursus.get_kursus_kategori!(kursus_kategori.id)
    end

    test "delete_kursus_kategori/1 deletes the kursus_kategori" do
      kursus_kategori = kursus_kategori_fixture()
      assert {:ok, %KursusKategori{}} = Kursus.delete_kursus_kategori(kursus_kategori)
      assert_raise Ecto.NoResultsError, fn -> Kursus.get_kursus_kategori!(kursus_kategori.id) end
    end

    test "change_kursus_kategori/1 returns a kursus_kategori changeset" do
      kursus_kategori = kursus_kategori_fixture()
      assert %Ecto.Changeset{} = Kursus.change_kursus_kategori(kursus_kategori)
    end
  end

  describe "kursus" do
    alias SpkpProject.Kursus.Kursuss

    import SpkpProject.KursusFixtures

    @invalid_attrs %{
      nama_kursus: nil,
      tarikh_mula: nil,
      tarikh_akhir: nil,
      tempat: nil,
      status_kursus: nil,
      had_umur: nil,
      anjuran: nil,
      gambar_anjuran: nil,
      gambar_kursus: nil,
      syarat_penyertaan: nil,
      syarat_pendidikan: nil,
      kuota: nil,
      tarikh_tutup: nil
    }

    test "list_kursus/0 returns all kursus" do
      kursuss = kursuss_fixture()
      assert Kursus.list_kursus() == [kursuss]
    end

    test "get_kursuss!/1 returns the kursuss with given id" do
      kursuss = kursuss_fixture()
      assert Kursus.get_kursuss!(kursuss.id) == kursuss
    end

    test "create_kursuss/1 with valid data creates a kursuss" do
      valid_attrs = %{
        nama_kursus: "some nama_kursus",
        tarikh_mula: ~D[2025-08-20],
        tarikh_akhir: ~D[2025-08-20],
        tempat: "some tempat",
        status_kursus: "some status_kursus",
        had_umur: 42,
        anjuran: "some anjuran",
        gambar_anjuran: "some gambar_anjuran",
        gambar_kursus: "some gambar_kursus",
        syarat_penyertaan: "some syarat_penyertaan",
        syarat_pendidikan: "some syarat_pendidikan",
        kuota: 42,
        tarikh_tutup: ~D[2025-08-20]
      }

      assert {:ok, %Kursuss{} = kursuss} = Kursus.create_kursuss(valid_attrs)
      assert kursuss.nama_kursus == "some nama_kursus"
      assert kursuss.tarikh_mula == ~D[2025-08-20]
      assert kursuss.tarikh_akhir == ~D[2025-08-20]
      assert kursuss.tempat == "some tempat"
      assert kursuss.status_kursus == "some status_kursus"
      assert kursuss.had_umur == 42
      assert kursuss.anjuran == "some anjuran"
      assert kursuss.gambar_anjuran == "some gambar_anjuran"
      assert kursuss.gambar_kursus == "some gambar_kursus"
      assert kursuss.syarat_penyertaan == "some syarat_penyertaan"
      assert kursuss.syarat_pendidikan == "some syarat_pendidikan"
      assert kursuss.kuota == 42
      assert kursuss.tarikh_tutup == ~D[2025-08-20]
    end

    test "create_kursuss/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Kursus.create_kursuss(@invalid_attrs)
    end

    test "update_kursuss/2 with valid data updates the kursuss" do
      kursuss = kursuss_fixture()

      update_attrs = %{
        nama_kursus: "some updated nama_kursus",
        tarikh_mula: ~D[2025-08-21],
        tarikh_akhir: ~D[2025-08-21],
        tempat: "some updated tempat",
        status_kursus: "some updated status_kursus",
        had_umur: 43,
        anjuran: "some updated anjuran",
        gambar_anjuran: "some updated gambar_anjuran",
        gambar_kursus: "some updated gambar_kursus",
        syarat_penyertaan: "some updated syarat_penyertaan",
        syarat_pendidikan: "some updated syarat_pendidikan",
        kuota: 43,
        tarikh_tutup: ~D[2025-08-21]
      }

      assert {:ok, %Kursuss{} = kursuss} = Kursus.update_kursuss(kursuss, update_attrs)
      assert kursuss.nama_kursus == "some updated nama_kursus"
      assert kursuss.tarikh_mula == ~D[2025-08-21]
      assert kursuss.tarikh_akhir == ~D[2025-08-21]
      assert kursuss.tempat == "some updated tempat"
      assert kursuss.status_kursus == "some updated status_kursus"
      assert kursuss.had_umur == 43
      assert kursuss.anjuran == "some updated anjuran"
      assert kursuss.gambar_anjuran == "some updated gambar_anjuran"
      assert kursuss.gambar_kursus == "some updated gambar_kursus"
      assert kursuss.syarat_penyertaan == "some updated syarat_penyertaan"
      assert kursuss.syarat_pendidikan == "some updated syarat_pendidikan"
      assert kursuss.kuota == 43
      assert kursuss.tarikh_tutup == ~D[2025-08-21]
    end

    test "update_kursuss/2 with invalid data returns error changeset" do
      kursuss = kursuss_fixture()
      assert {:error, %Ecto.Changeset{}} = Kursus.update_kursuss(kursuss, @invalid_attrs)
      assert kursuss == Kursus.get_kursuss!(kursuss.id)
    end

    test "delete_kursuss/1 deletes the kursuss" do
      kursuss = kursuss_fixture()
      assert {:ok, %Kursuss{}} = Kursus.delete_kursuss(kursuss)
      assert_raise Ecto.NoResultsError, fn -> Kursus.get_kursuss!(kursuss.id) end
    end

    test "change_kursuss/1 returns a kursuss changeset" do
      kursuss = kursuss_fixture()
      assert %Ecto.Changeset{} = Kursus.change_kursuss(kursuss)
    end
  end
end

defmodule SpkpProject.ElaunTest do
  use SpkpProject.DataCase

  alias SpkpProject.Elaun

  describe "elaun_pekerja" do
    alias SpkpProject.Elaun.ElaunPekerja

    import SpkpProject.ElaunFixtures

    @invalid_attrs %{tarikh_mula: nil, tarikh_akhir: nil, status_permohonan: nil, jumlah_keseluruhan: nil}

    test "list_elaun_pekerja/0 returns all elaun_pekerja" do
      elaun_pekerja = elaun_pekerja_fixture()
      assert Elaun.list_elaun_pekerja() == [elaun_pekerja]
    end

    test "get_elaun_pekerja!/1 returns the elaun_pekerja with given id" do
      elaun_pekerja = elaun_pekerja_fixture()
      assert Elaun.get_elaun_pekerja!(elaun_pekerja.id) == elaun_pekerja
    end

    test "create_elaun_pekerja/1 with valid data creates a elaun_pekerja" do
      valid_attrs = %{tarikh_mula: ~D[2025-08-26], tarikh_akhir: ~D[2025-08-26], status_permohonan: "some status_permohonan", jumlah_keseluruhan: "120.5"}

      assert {:ok, %ElaunPekerja{} = elaun_pekerja} = Elaun.create_elaun_pekerja(valid_attrs)
      assert elaun_pekerja.tarikh_mula == ~D[2025-08-26]
      assert elaun_pekerja.tarikh_akhir == ~D[2025-08-26]
      assert elaun_pekerja.status_permohonan == "some status_permohonan"
      assert elaun_pekerja.jumlah_keseluruhan == Decimal.new("120.5")
    end

    test "create_elaun_pekerja/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Elaun.create_elaun_pekerja(@invalid_attrs)
    end

    test "update_elaun_pekerja/2 with valid data updates the elaun_pekerja" do
      elaun_pekerja = elaun_pekerja_fixture()
      update_attrs = %{tarikh_mula: ~D[2025-08-27], tarikh_akhir: ~D[2025-08-27], status_permohonan: "some updated status_permohonan", jumlah_keseluruhan: "456.7"}

      assert {:ok, %ElaunPekerja{} = elaun_pekerja} = Elaun.update_elaun_pekerja(elaun_pekerja, update_attrs)
      assert elaun_pekerja.tarikh_mula == ~D[2025-08-27]
      assert elaun_pekerja.tarikh_akhir == ~D[2025-08-27]
      assert elaun_pekerja.status_permohonan == "some updated status_permohonan"
      assert elaun_pekerja.jumlah_keseluruhan == Decimal.new("456.7")
    end

    test "update_elaun_pekerja/2 with invalid data returns error changeset" do
      elaun_pekerja = elaun_pekerja_fixture()
      assert {:error, %Ecto.Changeset{}} = Elaun.update_elaun_pekerja(elaun_pekerja, @invalid_attrs)
      assert elaun_pekerja == Elaun.get_elaun_pekerja!(elaun_pekerja.id)
    end

    test "delete_elaun_pekerja/1 deletes the elaun_pekerja" do
      elaun_pekerja = elaun_pekerja_fixture()
      assert {:ok, %ElaunPekerja{}} = Elaun.delete_elaun_pekerja(elaun_pekerja)
      assert_raise Ecto.NoResultsError, fn -> Elaun.get_elaun_pekerja!(elaun_pekerja.id) end
    end

    test "change_elaun_pekerja/1 returns a elaun_pekerja changeset" do
      elaun_pekerja = elaun_pekerja_fixture()
      assert %Ecto.Changeset{} = Elaun.change_elaun_pekerja(elaun_pekerja)
    end
  end
end

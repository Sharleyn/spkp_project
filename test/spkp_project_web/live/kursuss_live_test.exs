defmodule SpkpProjectWeb.KursussLiveTest do
  use SpkpProjectWeb.ConnCase

  import Phoenix.LiveViewTest
  import SpkpProject.KursusFixtures

  @create_attrs %{
    nama_kursus: "some nama_kursus",
    tarikh_mula: "2025-08-20",
    tarikh_akhir: "2025-08-20",
    tempat: "some tempat",
    status_kursus: "some status_kursus",
    had_umur: 42,
    anjuran: "some anjuran",
    gambar_anjuran: "some gambar_anjuran",
    gambar_kursus: "some gambar_kursus",
    syarat_penyertaan: "some syarat_penyertaan",
    syarat_pendidikan: "some syarat_pendidikan",
    kuota: 42,
    tarikh_tutup: "2025-08-20"
  }
  @update_attrs %{
    nama_kursus: "some updated nama_kursus",
    tarikh_mula: "2025-08-21",
    tarikh_akhir: "2025-08-21",
    tempat: "some updated tempat",
    status_kursus: "some updated status_kursus",
    had_umur: 43,
    anjuran: "some updated anjuran",
    gambar_anjuran: "some updated gambar_anjuran",
    gambar_kursus: "some updated gambar_kursus",
    syarat_penyertaan: "some updated syarat_penyertaan",
    syarat_pendidikan: "some updated syarat_pendidikan",
    kuota: 43,
    tarikh_tutup: "2025-08-21"
  }
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

  defp create_kursuss(_) do
    kursuss = kursuss_fixture()
    %{kursuss: kursuss}
  end

  describe "Index" do
    setup [:create_kursuss]

    test "lists all kursus", %{conn: conn, kursuss: kursuss} do
      {:ok, _index_live, html} = live(conn, ~p"/kursus")

      assert html =~ "Listing Kursus"
      assert html =~ kursuss.nama_kursus
    end

    test "saves new kursuss", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/kursus")

      assert index_live |> element("a", "New Kursuss") |> render_click() =~
               "New Kursuss"

      assert_patch(index_live, ~p"/kursus/new")

      assert index_live
             |> form("#kursuss-form", kursuss: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#kursuss-form", kursuss: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/kursus")

      html = render(index_live)
      assert html =~ "Kursuss created successfully"
      assert html =~ "some nama_kursus"
    end

    test "updates kursuss in listing", %{conn: conn, kursuss: kursuss} do
      {:ok, index_live, _html} = live(conn, ~p"/kursus")

      assert index_live |> element("#kursus-#{kursuss.id} a", "Edit") |> render_click() =~
               "Edit Kursuss"

      assert_patch(index_live, ~p"/kursus/#{kursuss}/edit")

      assert index_live
             |> form("#kursuss-form", kursuss: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#kursuss-form", kursuss: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/kursus")

      html = render(index_live)
      assert html =~ "Kursuss updated successfully"
      assert html =~ "some updated nama_kursus"
    end

    test "deletes kursuss in listing", %{conn: conn, kursuss: kursuss} do
      {:ok, index_live, _html} = live(conn, ~p"/kursus")

      assert index_live |> element("#kursus-#{kursuss.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#kursus-#{kursuss.id}")
    end
  end

  describe "Show" do
    setup [:create_kursuss]

    test "displays kursuss", %{conn: conn, kursuss: kursuss} do
      {:ok, _show_live, html} = live(conn, ~p"/kursus/#{kursuss}")

      assert html =~ "Show Kursuss"
      assert html =~ kursuss.nama_kursus
    end

    test "updates kursuss within modal", %{conn: conn, kursuss: kursuss} do
      {:ok, show_live, _html} = live(conn, ~p"/kursus/#{kursuss}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Kursuss"

      assert_patch(show_live, ~p"/kursus/#{kursuss}/show/edit")

      assert show_live
             |> form("#kursuss-form", kursuss: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#kursuss-form", kursuss: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/kursus/#{kursuss}")

      html = render(show_live)
      assert html =~ "Kursuss updated successfully"
      assert html =~ "some updated nama_kursus"
    end
  end
end

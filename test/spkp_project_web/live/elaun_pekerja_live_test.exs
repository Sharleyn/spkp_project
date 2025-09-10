defmodule SpkpProjectWeb.ElaunPekerjaLiveTest do
  use SpkpProjectWeb.ConnCase

  import Phoenix.LiveViewTest
  import SpkpProject.ElaunFixtures

  @create_attrs %{tarikh_mula: "2025-08-26", tarikh_akhir: "2025-08-26", status_permohonan: "some status_permohonan", jumlah_keseluruhan: "120.5"}
  @update_attrs %{tarikh_mula: "2025-08-27", tarikh_akhir: "2025-08-27", status_permohonan: "some updated status_permohonan", jumlah_keseluruhan: "456.7"}
  @invalid_attrs %{tarikh_mula: nil, tarikh_akhir: nil, status_permohonan: nil, jumlah_keseluruhan: nil}

  defp create_elaun_pekerja(_) do
    elaun_pekerja = elaun_pekerja_fixture()
    %{elaun_pekerja: elaun_pekerja}
  end

  describe "Index" do
    setup [:create_elaun_pekerja]

    test "lists all elaun_pekerja", %{conn: conn, elaun_pekerja: elaun_pekerja} do
      {:ok, _index_live, html} = live(conn, ~p"/elaun_pekerja")

      assert html =~ "Listing Elaun pekerja"
      assert html =~ elaun_pekerja.status_permohonan
    end

    test "saves new elaun_pekerja", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/elaun_pekerja")

      assert index_live |> element("a", "New Elaun pekerja") |> render_click() =~
               "New Elaun pekerja"

      assert_patch(index_live, ~p"/elaun_pekerja/new")

      assert index_live
             |> form("#elaun_pekerja-form", elaun_pekerja: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#elaun_pekerja-form", elaun_pekerja: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/elaun_pekerja")

      html = render(index_live)
      assert html =~ "Elaun pekerja created successfully"
      assert html =~ "some status_permohonan"
    end

    test "updates elaun_pekerja in listing", %{conn: conn, elaun_pekerja: elaun_pekerja} do
      {:ok, index_live, _html} = live(conn, ~p"/elaun_pekerja")

      assert index_live |> element("#elaun_pekerja-#{elaun_pekerja.id} a", "Edit") |> render_click() =~
               "Edit Elaun pekerja"

      assert_patch(index_live, ~p"/elaun_pekerja/#{elaun_pekerja}/edit")

      assert index_live
             |> form("#elaun_pekerja-form", elaun_pekerja: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#elaun_pekerja-form", elaun_pekerja: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/elaun_pekerja")

      html = render(index_live)
      assert html =~ "Elaun pekerja updated successfully"
      assert html =~ "some updated status_permohonan"
    end

    test "deletes elaun_pekerja in listing", %{conn: conn, elaun_pekerja: elaun_pekerja} do
      {:ok, index_live, _html} = live(conn, ~p"/elaun_pekerja")

      assert index_live |> element("#elaun_pekerja-#{elaun_pekerja.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#elaun_pekerja-#{elaun_pekerja.id}")
    end
  end

  describe "Show" do
    setup [:create_elaun_pekerja]

    test "displays elaun_pekerja", %{conn: conn, elaun_pekerja: elaun_pekerja} do
      {:ok, _show_live, html} = live(conn, ~p"/elaun_pekerja/#{elaun_pekerja}")

      assert html =~ "Show Elaun pekerja"
      assert html =~ elaun_pekerja.status_permohonan
    end

    test "updates elaun_pekerja within modal", %{conn: conn, elaun_pekerja: elaun_pekerja} do
      {:ok, show_live, _html} = live(conn, ~p"/elaun_pekerja/#{elaun_pekerja}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Elaun pekerja"

      assert_patch(show_live, ~p"/elaun_pekerja/#{elaun_pekerja}/show/edit")

      assert show_live
             |> form("#elaun_pekerja-form", elaun_pekerja: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#elaun_pekerja-form", elaun_pekerja: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/elaun_pekerja/#{elaun_pekerja}")

      html = render(show_live)
      assert html =~ "Elaun pekerja updated successfully"
      assert html =~ "some updated status_permohonan"
    end
  end
end

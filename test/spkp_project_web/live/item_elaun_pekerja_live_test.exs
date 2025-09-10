defmodule SpkpProjectWeb.ItemElaunPekerjaLiveTest do
  use SpkpProjectWeb.ConnCase

  import Phoenix.LiveViewTest
  import SpkpProject.ElaunFixtures

  @create_attrs %{kenyataan_tuntutan: "some kenyataan_tuntutan", tarikh_tuntutan: "2025-08-27", masa_mula: "14:00", masa_tamat: "14:00", keterangan: "some keterangan", jumlah: "120.5"}
  @update_attrs %{kenyataan_tuntutan: "some updated kenyataan_tuntutan", tarikh_tuntutan: "2025-08-28", masa_mula: "15:01", masa_tamat: "15:01", keterangan: "some updated keterangan", jumlah: "456.7"}
  @invalid_attrs %{kenyataan_tuntutan: nil, tarikh_tuntutan: nil, masa_mula: nil, masa_tamat: nil, keterangan: nil, jumlah: nil}

  defp create_item_elaun_pekerja(_) do
    item_elaun_pekerja = item_elaun_pekerja_fixture()
    %{item_elaun_pekerja: item_elaun_pekerja}
  end

  describe "Index" do
    setup [:create_item_elaun_pekerja]

    test "lists all item_elaun_pekerja", %{conn: conn, item_elaun_pekerja: item_elaun_pekerja} do
      {:ok, _index_live, html} = live(conn, ~p"/item_elaun_pekerja")

      assert html =~ "Listing Item elaun pekerja"
      assert html =~ item_elaun_pekerja.kenyataan_tuntutan
    end

    test "saves new item_elaun_pekerja", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/item_elaun_pekerja")

      assert index_live |> element("a", "New Item elaun pekerja") |> render_click() =~
               "New Item elaun pekerja"

      assert_patch(index_live, ~p"/item_elaun_pekerja/new")

      assert index_live
             |> form("#item_elaun_pekerja-form", item_elaun_pekerja: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#item_elaun_pekerja-form", item_elaun_pekerja: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/item_elaun_pekerja")

      html = render(index_live)
      assert html =~ "Item elaun pekerja created successfully"
      assert html =~ "some kenyataan_tuntutan"
    end

    test "updates item_elaun_pekerja in listing", %{conn: conn, item_elaun_pekerja: item_elaun_pekerja} do
      {:ok, index_live, _html} = live(conn, ~p"/item_elaun_pekerja")

      assert index_live |> element("#item_elaun_pekerja-#{item_elaun_pekerja.id} a", "Edit") |> render_click() =~
               "Edit Item elaun pekerja"

      assert_patch(index_live, ~p"/item_elaun_pekerja/#{item_elaun_pekerja}/edit")

      assert index_live
             |> form("#item_elaun_pekerja-form", item_elaun_pekerja: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#item_elaun_pekerja-form", item_elaun_pekerja: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/item_elaun_pekerja")

      html = render(index_live)
      assert html =~ "Item elaun pekerja updated successfully"
      assert html =~ "some updated kenyataan_tuntutan"
    end

    test "deletes item_elaun_pekerja in listing", %{conn: conn, item_elaun_pekerja: item_elaun_pekerja} do
      {:ok, index_live, _html} = live(conn, ~p"/item_elaun_pekerja")

      assert index_live |> element("#item_elaun_pekerja-#{item_elaun_pekerja.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#item_elaun_pekerja-#{item_elaun_pekerja.id}")
    end
  end

  describe "Show" do
    setup [:create_item_elaun_pekerja]

    test "displays item_elaun_pekerja", %{conn: conn, item_elaun_pekerja: item_elaun_pekerja} do
      {:ok, _show_live, html} = live(conn, ~p"/item_elaun_pekerja/#{item_elaun_pekerja}")

      assert html =~ "Show Item elaun pekerja"
      assert html =~ item_elaun_pekerja.kenyataan_tuntutan
    end

    test "updates item_elaun_pekerja within modal", %{conn: conn, item_elaun_pekerja: item_elaun_pekerja} do
      {:ok, show_live, _html} = live(conn, ~p"/item_elaun_pekerja/#{item_elaun_pekerja}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Item elaun pekerja"

      assert_patch(show_live, ~p"/item_elaun_pekerja/#{item_elaun_pekerja}/show/edit")

      assert show_live
             |> form("#item_elaun_pekerja-form", item_elaun_pekerja: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#item_elaun_pekerja-form", item_elaun_pekerja: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/item_elaun_pekerja/#{item_elaun_pekerja}")

      html = render(show_live)
      assert html =~ "Item elaun pekerja updated successfully"
      assert html =~ "some updated kenyataan_tuntutan"
    end
  end
end

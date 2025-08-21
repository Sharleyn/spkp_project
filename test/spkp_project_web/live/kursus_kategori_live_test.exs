defmodule SpkpProjectWeb.KursusKategoriLiveTest do
  use SpkpProjectWeb.ConnCase

  import Phoenix.LiveViewTest
  import SpkpProject.KursusFixtures

  @create_attrs %{kategori: "some kategori"}
  @update_attrs %{kategori: "some updated kategori"}
  @invalid_attrs %{kategori: nil}

  defp create_kursus_kategori(_) do
    kursus_kategori = kursus_kategori_fixture()
    %{kursus_kategori: kursus_kategori}
  end

  describe "Index" do
    setup [:create_kursus_kategori]

    test "lists all kursus_kategori", %{conn: conn, kursus_kategori: kursus_kategori} do
      {:ok, _index_live, html} = live(conn, ~p"/kursus_kategori")

      assert html =~ "Listing Kursus kategori"
      assert html =~ kursus_kategori.kategori
    end

    test "saves new kursus_kategori", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/kursus_kategori")

      assert index_live |> element("a", "New Kursus kategori") |> render_click() =~
               "New Kursus kategori"

      assert_patch(index_live, ~p"/kursus_kategori/new")

      assert index_live
             |> form("#kursus_kategori-form", kursus_kategori: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#kursus_kategori-form", kursus_kategori: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/kursus_kategori")

      html = render(index_live)
      assert html =~ "Kursus kategori created successfully"
      assert html =~ "some kategori"
    end

    test "updates kursus_kategori in listing", %{conn: conn, kursus_kategori: kursus_kategori} do
      {:ok, index_live, _html} = live(conn, ~p"/kursus_kategori")

      assert index_live |> element("#kursus_kategori-#{kursus_kategori.id} a", "Edit") |> render_click() =~
               "Edit Kursus kategori"

      assert_patch(index_live, ~p"/kursus_kategori/#{kursus_kategori}/edit")

      assert index_live
             |> form("#kursus_kategori-form", kursus_kategori: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#kursus_kategori-form", kursus_kategori: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/kursus_kategori")

      html = render(index_live)
      assert html =~ "Kursus kategori updated successfully"
      assert html =~ "some updated kategori"
    end

    test "deletes kursus_kategori in listing", %{conn: conn, kursus_kategori: kursus_kategori} do
      {:ok, index_live, _html} = live(conn, ~p"/kursus_kategori")

      assert index_live |> element("#kursus_kategori-#{kursus_kategori.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#kursus_kategori-#{kursus_kategori.id}")
    end
  end

  describe "Show" do
    setup [:create_kursus_kategori]

    test "displays kursus_kategori", %{conn: conn, kursus_kategori: kursus_kategori} do
      {:ok, _show_live, html} = live(conn, ~p"/kursus_kategori/#{kursus_kategori}")

      assert html =~ "Show Kursus kategori"
      assert html =~ kursus_kategori.kategori
    end

    test "updates kursus_kategori within modal", %{conn: conn, kursus_kategori: kursus_kategori} do
      {:ok, show_live, _html} = live(conn, ~p"/kursus_kategori/#{kursus_kategori}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Kursus kategori"

      assert_patch(show_live, ~p"/kursus_kategori/#{kursus_kategori}/show/edit")

      assert show_live
             |> form("#kursus_kategori-form", kursus_kategori: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#kursus_kategori-form", kursus_kategori: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/kursus_kategori/#{kursus_kategori}")

      html = render(show_live)
      assert html =~ "Kursus kategori updated successfully"
      assert html =~ "some updated kategori"
    end
  end
end

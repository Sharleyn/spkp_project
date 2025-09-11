defmodule SpkpProjectWeb.MaklumatPekerjaLiveTest do
  use SpkpProjectWeb.ConnCase

  import Phoenix.LiveViewTest
  import SpkpProject.AccountsFixtures

  @create_attrs %{no_ic: "some no_ic", no_tel: "some no_tel", nama_bank: "some nama_bank", no_akaun: "some no_akaun"}
  @update_attrs %{no_ic: "some updated no_ic", no_tel: "some updated no_tel", nama_bank: "some updated nama_bank", no_akaun: "some updated no_akaun"}
  @invalid_attrs %{no_ic: nil, no_tel: nil, nama_bank: nil, no_akaun: nil}

  defp create_maklumat_pekerja(_) do
    maklumat_pekerja = maklumat_pekerja_fixture()
    %{maklumat_pekerja: maklumat_pekerja}
  end

  describe "Index" do
    setup [:create_maklumat_pekerja]

    test "lists all maklumat_pekerja", %{conn: conn, maklumat_pekerja: maklumat_pekerja} do
      {:ok, _index_live, html} = live(conn, ~p"/maklumat_pekerja")

      assert html =~ "Listing Maklumat pekerja"
      assert html =~ maklumat_pekerja.no_ic
    end

    test "saves new maklumat_pekerja", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/maklumat_pekerja")

      assert index_live |> element("a", "New Maklumat pekerja") |> render_click() =~
               "New Maklumat pekerja"

      assert_patch(index_live, ~p"/maklumat_pekerja/new")

      assert index_live
             |> form("#maklumat_pekerja-form", maklumat_pekerja: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#maklumat_pekerja-form", maklumat_pekerja: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/maklumat_pekerja")

      html = render(index_live)
      assert html =~ "Maklumat pekerja created successfully"
      assert html =~ "some no_ic"
    end

    test "updates maklumat_pekerja in listing", %{conn: conn, maklumat_pekerja: maklumat_pekerja} do
      {:ok, index_live, _html} = live(conn, ~p"/maklumat_pekerja")

      assert index_live |> element("#maklumat_pekerja-#{maklumat_pekerja.id} a", "Edit") |> render_click() =~
               "Edit Maklumat pekerja"

      assert_patch(index_live, ~p"/maklumat_pekerja/#{maklumat_pekerja}/edit")

      assert index_live
             |> form("#maklumat_pekerja-form", maklumat_pekerja: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#maklumat_pekerja-form", maklumat_pekerja: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/maklumat_pekerja")

      html = render(index_live)
      assert html =~ "Maklumat pekerja updated successfully"
      assert html =~ "some updated no_ic"
    end

    test "deletes maklumat_pekerja in listing", %{conn: conn, maklumat_pekerja: maklumat_pekerja} do
      {:ok, index_live, _html} = live(conn, ~p"/maklumat_pekerja")

      assert index_live |> element("#maklumat_pekerja-#{maklumat_pekerja.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#maklumat_pekerja-#{maklumat_pekerja.id}")
    end
  end

  describe "Show" do
    setup [:create_maklumat_pekerja]

    test "displays maklumat_pekerja", %{conn: conn, maklumat_pekerja: maklumat_pekerja} do
      {:ok, _show_live, html} = live(conn, ~p"/maklumat_pekerja/#{maklumat_pekerja}")

      assert html =~ "Show Maklumat pekerja"
      assert html =~ maklumat_pekerja.no_ic
    end

    test "updates maklumat_pekerja within modal", %{conn: conn, maklumat_pekerja: maklumat_pekerja} do
      {:ok, show_live, _html} = live(conn, ~p"/maklumat_pekerja/#{maklumat_pekerja}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Maklumat pekerja"

      assert_patch(show_live, ~p"/maklumat_pekerja/#{maklumat_pekerja}/show/edit")

      assert show_live
             |> form("#maklumat_pekerja-form", maklumat_pekerja: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#maklumat_pekerja-form", maklumat_pekerja: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/maklumat_pekerja/#{maklumat_pekerja}")

      html = render(show_live)
      assert html =~ "Maklumat pekerja updated successfully"
      assert html =~ "some updated no_ic"
    end
  end
end

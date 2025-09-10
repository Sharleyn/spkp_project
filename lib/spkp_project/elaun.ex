defmodule SpkpProject.Elaun do
  @moduledoc """
  The Elaun context.
  """

  import Ecto.Query, warn: false
  alias SpkpProject.Repo

  alias SpkpProject.Elaun.{ElaunPekerja, ItemElaunPekerja}

  # -------------------------
  # ELAUN PEKERJA
  # -------------------------

  def list_elaun_pekerja do
    Repo.all(ElaunPekerja)
    |> Repo.preload(maklumat_pekerja: :user)
  end

  def get_elaun_pekerja!(id, preloads \\ []) do
    ElaunPekerja
    |> Repo.get!(id)
    |> Repo.preload([maklumat_pekerja: :user] ++ preloads)
  end

  def create_elaun_pekerja(attrs \\ %{}) do
    %ElaunPekerja{}
    |> ElaunPekerja.changeset(attrs)
    |> Repo.insert()
  end

  def update_elaun_pekerja(%ElaunPekerja{} = elaun_pekerja, attrs) do
    elaun_pekerja
    |> ElaunPekerja.changeset(attrs)
    |> Repo.update()
  end

  def delete_elaun_pekerja(%ElaunPekerja{} = elaun_pekerja) do
    Repo.delete(elaun_pekerja)
  end

  def change_elaun_pekerja(%ElaunPekerja{} = elaun_pekerja, attrs \\ %{}) do
    ElaunPekerja.changeset(elaun_pekerja, attrs)
  end

  # -------------------------
  # ITEM ELAUN PEKERJA
  # -------------------------

  def list_item_elaun_pekerja do
    Repo.all(ItemElaunPekerja)
  end

  def list_item_elaun_pekerja_by_user(user_id) do
    from(i in ItemElaunPekerja,
      join: e in assoc(i, :elaun_pekerja),
      join: m in assoc(e, :maklumat_pekerja),
      where: m.user_id == ^user_id,
      preload: [elaun_pekerja: [maklumat_pekerja: :user]]
    )
    |> Repo.all()
  end

  def get_item_elaun_pekerja!(id) do
    ItemElaunPekerja
    |> Repo.get!(id)
    |> Repo.preload(elaun_pekerja: [maklumat_pekerja: :user])
  end

  def create_item_elaun_pekerja(attrs \\ %{}) do
    %ItemElaunPekerja{}
    |> ItemElaunPekerja.changeset(attrs)
    |> Repo.insert()
  end

  def update_item_elaun_pekerja(%ItemElaunPekerja{} = item, attrs) do
    item
    |> ItemElaunPekerja.changeset(attrs)
    |> Repo.update()
  end

  def delete_item_elaun_pekerja(%ItemElaunPekerja{} = item) do
    Repo.delete(item)
  end

  def change_item_elaun_pekerja(%ItemElaunPekerja{} = item, attrs \\ %{}) do
    ItemElaunPekerja.changeset(item, attrs)
  end
end

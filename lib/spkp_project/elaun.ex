defmodule SpkpProject.Elaun do
  @moduledoc """
  The Elaun context.
  """

  import Ecto.Query, warn: false
  alias SpkpProject.Repo

  alias SpkpProject.Elaun.ElaunPekerja
  alias SpkpProject.Elaun.ItemElaunPekerja

  @doc """
  Returns the list of elaun_pekerja.

  ## Examples

      iex> list_elaun_pekerja()
      [%ElaunPekerja{}, ...]

  """
 def list_elaun_pekerja do
  Repo.all(ElaunPekerja)
  |> Repo.preload(maklumat_pekerja: :user)
end


  @doc """
  Gets a single elaun_pekerja.

  Raises `Ecto.NoResultsError` if the Elaun pekerja does not exist.

  ## Examples

      iex> get_elaun_pekerja!(123)
      %ElaunPekerja{}

      iex> get_elaun_pekerja!(456)
      ** (Ecto.NoResultsError)

  """
  def get_elaun_pekerja!(id) do
    Repo.get!(ElaunPekerja, id)
    |> Repo.preload(maklumat_pekerja: :user)
  end


  @doc """
  Creates a elaun_pekerja.

  ## Examples

      iex> create_elaun_pekerja(%{field: value})
      {:ok, %ElaunPekerja{}}

      iex> create_elaun_pekerja(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_elaun_pekerja(attrs \\ %{}) do
    %ElaunPekerja{}
    |> ElaunPekerja.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a elaun_pekerja.

  ## Examples

      iex> update_elaun_pekerja(elaun_pekerja, %{field: new_value})
      {:ok, %ElaunPekerja{}}

      iex> update_elaun_pekerja(elaun_pekerja, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_elaun_pekerja(%ElaunPekerja{} = elaun_pekerja, attrs) do
    elaun_pekerja
    |> ElaunPekerja.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a elaun_pekerja.

  ## Examples

      iex> delete_elaun_pekerja(elaun_pekerja)
      {:ok, %ElaunPekerja{}}

      iex> delete_elaun_pekerja(elaun_pekerja)
      {:error, %Ecto.Changeset{}}

  """
  def delete_elaun_pekerja(%ElaunPekerja{} = elaun_pekerja) do
    Repo.delete(elaun_pekerja)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking elaun_pekerja changes.

  ## Examples

      iex> change_elaun_pekerja(elaun_pekerja)
      %Ecto.Changeset{data: %ElaunPekerja{}}

  """
  def change_elaun_pekerja(%ElaunPekerja{} = elaun_pekerja, attrs \\ %{}) do
    ElaunPekerja.changeset(elaun_pekerja, attrs)
  end

  alias SpkpProject.Elaun.ItemElaunPekerja

  @doc """
  Returns the list of item_elaun_pekerja.

  ## Examples

      iex> list_item_elaun_pekerja()
      [%ItemElaunPekerja{}, ...]

  """
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


  @doc """
  Gets a single item_elaun_pekerja.

  Raises `Ecto.NoResultsError` if the Item elaun pekerja does not exist.

  ## Examples

      iex> get_item_elaun_pekerja!(123)
      %ItemElaunPekerja{}

      iex> get_item_elaun_pekerja!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item_elaun_pekerja!(id), do: Repo.get!(ItemElaunPekerja, id)

  @doc """
  Creates a item_elaun_pekerja.

  ## Examples

      iex> create_item_elaun_pekerja(%{field: value})
      {:ok, %ItemElaunPekerja{}}

      iex> create_item_elaun_pekerja(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item_elaun_pekerja(attrs \\ %{}) do
    %ItemElaunPekerja{}
    |> ItemElaunPekerja.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item_elaun_pekerja.

  ## Examples

      iex> update_item_elaun_pekerja(item_elaun_pekerja, %{field: new_value})
      {:ok, %ItemElaunPekerja{}}

      iex> update_item_elaun_pekerja(item_elaun_pekerja, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item_elaun_pekerja(%ItemElaunPekerja{} = item_elaun_pekerja, attrs) do
    item_elaun_pekerja
    |> ItemElaunPekerja.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item_elaun_pekerja.

  ## Examples

      iex> delete_item_elaun_pekerja(item_elaun_pekerja)
      {:ok, %ItemElaunPekerja{}}

      iex> delete_item_elaun_pekerja(item_elaun_pekerja)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item_elaun_pekerja(%ItemElaunPekerja{} = item_elaun_pekerja) do
    Repo.delete(item_elaun_pekerja)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item_elaun_pekerja changes.

  ## Examples

      iex> change_item_elaun_pekerja(item_elaun_pekerja)
      %Ecto.Changeset{data: %ItemElaunPekerja{}}

  """
  def change_item_elaun_pekerja(%ItemElaunPekerja{} = item_elaun_pekerja, attrs \\ %{}) do
    ItemElaunPekerja.changeset(item_elaun_pekerja, attrs)
  end
end

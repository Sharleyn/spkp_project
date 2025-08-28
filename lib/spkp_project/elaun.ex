defmodule SpkpProject.Elaun do
  @moduledoc """
  The Elaun context.
  """

  import Ecto.Query, warn: false
  alias SpkpProject.Repo

  alias SpkpProject.Elaun.ElaunPekerja

  @doc """
  Returns the list of elaun_pekerja.

  ## Examples

      iex> list_elaun_pekerja()
      [%ElaunPekerja{}, ...]

  """
  def list_elaun_pekerja do
    Repo.all(
      from e in ElaunPekerja,
        join: m in assoc(e, :maklumat_pekerja),
        join: u in assoc(m, :user),
        preload: [maklumat_pekerja: {m, user: u}]
    )
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
  def get_elaun_pekerja!(id), do: Repo.get!(ElaunPekerja, id)

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
end

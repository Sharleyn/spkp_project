defmodule SpkpProject.Kursus do
  @moduledoc """
  The Kursus context.
  """

  import Ecto.Query, warn: false
  alias SpkpProject.Repo

  alias SpkpProject.Kursus.KursusKategori

  @doc """
  Returns the list of kursus_kategori.

  ## Examples

      iex> list_kursus_kategori()
      [%KursusKategori{}, ...]

  """
  def list_kursus_kategori do
    Repo.all(KursusKategori)
  end

  @doc """
  Gets a single kursus_kategori.

  Raises `Ecto.NoResultsError` if the Kursus kategori does not exist.

  ## Examples

      iex> get_kursus_kategori!(123)
      %KursusKategori{}

      iex> get_kursus_kategori!(456)
      ** (Ecto.NoResultsError)

  """
  def get_kursus_kategori!(id), do: Repo.get!(KursusKategori, id)

  @doc """
  Creates a kursus_kategori.

  ## Examples

      iex> create_kursus_kategori(%{field: value})
      {:ok, %KursusKategori{}}

      iex> create_kursus_kategori(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_kursus_kategori(attrs \\ %{}) do
    %KursusKategori{}
    |> KursusKategori.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a kursus_kategori.

  ## Examples

      iex> update_kursus_kategori(kursus_kategori, %{field: new_value})
      {:ok, %KursusKategori{}}

      iex> update_kursus_kategori(kursus_kategori, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_kursus_kategori(%KursusKategori{} = kursus_kategori, attrs) do
    kursus_kategori
    |> KursusKategori.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a kursus_kategori.

  ## Examples

      iex> delete_kursus_kategori(kursus_kategori)
      {:ok, %KursusKategori{}}

      iex> delete_kursus_kategori(kursus_kategori)
      {:error, %Ecto.Changeset{}}

  """
  def delete_kursus_kategori(%KursusKategori{} = kursus_kategori) do
    Repo.delete(kursus_kategori)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking kursus_kategori changes.

  ## Examples

      iex> change_kursus_kategori(kursus_kategori)
      %Ecto.Changeset{data: %KursusKategori{}}

  """
  def change_kursus_kategori(%KursusKategori{} = kursus_kategori, attrs \\ %{}) do
    KursusKategori.changeset(kursus_kategori, attrs)
  end

  alias SpkpProject.Kursus.Kursuss

  @doc """
  Returns the list of kursus.

  ## Examples

      iex> list_kursus()
      [%Kursuss{}, ...]

  """
  def list_kursus do
    Repo.all(Kursuss)
  end

  @doc """
  Gets a single kursuss.

  Raises `Ecto.NoResultsError` if the Kursuss does not exist.

  ## Examples

      iex> get_kursuss!(123)
      %Kursuss{}

      iex> get_kursuss!(456)
      ** (Ecto.NoResultsError)

  """
  def get_kursuss!(id), do: Repo.get!(Kursuss, id)

  @doc """
  Creates a kursuss.

  ## Examples

      iex> create_kursuss(%{field: value})
      {:ok, %Kursuss{}}

      iex> create_kursuss(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_kursuss(attrs \\ %{}) do
    %Kursuss{}
    |> Kursuss.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a kursuss.

  ## Examples

      iex> update_kursuss(kursuss, %{field: new_value})
      {:ok, %Kursuss{}}

      iex> update_kursuss(kursuss, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_kursuss(%Kursuss{} = kursuss, attrs) do
    kursuss
    |> Kursuss.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a kursuss.

  ## Examples

      iex> delete_kursuss(kursuss)
      {:ok, %Kursuss{}}

      iex> delete_kursuss(kursuss)
      {:error, %Ecto.Changeset{}}

  """
  def delete_kursuss(%Kursuss{} = kursuss) do
    Repo.delete(kursuss)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking kursuss changes.

  ## Examples

      iex> change_kursuss(kursuss)
      %Ecto.Changeset{data: %Kursuss{}}

  """
  def change_kursuss(%Kursuss{} = kursuss, attrs \\ %{}) do
    Kursuss.changeset(kursuss, attrs)
  end
end

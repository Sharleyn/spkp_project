defmodule SpkpProject.Kursus do
  @moduledoc """
  The Kursus context.
  """

  import Ecto.Query, warn: false
  alias SpkpProject.Repo

  alias SpkpProject.Kursus.Kursuss
  alias SpkpProject.Kursus.KursusKategori
  alias SpkpProject.{Repo, Kursus.Kursuss, Userpermohonan.Userpermohonan}

  @doc """
  Returns the list of kursus_kategori.

  ## Examples

      iex> list_kursus_kategori()
      [%KursusKategori{}, ...]

  """
  def list_kursus_kategori do
    Repo.all(KursusKategori)
  end

  #Tambah pagination di Kursus kategori
  def list_kursus_kategori_paginated(page \\ 1, per_page \\ 5) do
    query = from k in KursusKategori, order_by: [asc: k.kategori]

    total_entries = Repo.aggregate(query, :count, :id)

    entries =
      query
      |> limit(^per_page)
      |> offset(^((page - 1) * per_page))
      |> Repo.all()

      total_pages = div(total_entries + per_page - 1, per_page)

    %{
      entries: entries,
      page: page,
      per_page: per_page,
      total_entries: total_entries,
      total_pages: total_pages
    }
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
  Repo.all(Kursuss) |> Repo.preload(:kursus_kategori)
end

def list_all_courses do
  Kursuss
  |> order_by([k], asc: k.tarikh_mula)  # ikut tarikh mula kalau mahu
  |> Repo.all()
end

def list_kursus_paginated(page \\ 1, per_page \\ 5) do
  offset = (page - 1) * per_page

  query =
    from k in Kursuss,
      order_by: [desc: k.inserted_at],
      offset: ^offset,
      limit: ^per_page

  data = Repo.all(query)

  total_count = Repo.aggregate(Kursuss, :count, :id)

  %{
    data: data,
    page: page,
    per_page: per_page,
    total_count: total_count,
    total_pages: div(total_count + per_page - 1, per_page)
  }
end

def search_kursus(query, page \\ 1, per_page \\ 5) do
  offset = (page - 1) * per_page

  base_query =
    from k in Kursuss,
      where: ilike(k.nama_kursus, ^"%#{query}%"),
      order_by: [desc: k.inserted_at],
      offset: ^offset,
      limit: ^per_page

  data = Repo.all(base_query)

  total_count =
    from(k in Kursuss, where: ilike(k.nama_kursus, ^"%#{query}%"))
    |> Repo.aggregate(:count, :id)

  %{
    data: data,
    page: page,
    per_page: per_page,
    total_count: total_count,
    total_pages: div(total_count + per_page - 1, per_page)
  }
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

  def get_available_courses_count do
    from(k in Kursuss,
      where: k.status_kursus in ["Buka", "Tutup"]
    )
    |> Repo.aggregate(:count, :id)
  end

  # Statistik jumlah peserta per kursus
  def statistics do
    from(k in Kursuss,
      left_join: p in Userpermohonan, on: p.kursus_id == k.id,
      group_by: k.id,
      select: %{
        nama_kursus: k.nama_kursus,
        jumlah_peserta: count(p.id)
      }
    )
    |> Repo.all()
  end

  def count_program do
    import Ecto.Query

    from(k in SpkpProject.Kursus.Kursuss)  # ✅ guna schema sebenar
    |> SpkpProject.Repo.aggregate(:count, :id)
  end

  def count_kategori do
    import Ecto.Query
    from(c in SpkpProject.Kursus.KursusKategori) # <-- table kategori kamu
    |> SpkpProject.Repo.aggregate(:count, :id)
  end
end

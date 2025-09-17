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

  def list_all_elaun_pekerja do
    Repo.all(ElaunPekerja)
    |> Repo.preload([:item_elaun_pekerja, maklumat_pekerja: :user])
  end

  # ✅ Pagination function
  def list_elaun_pekerja_paginated(page \\ 1, per_page \\ 5) do
    offset = (page - 1) * per_page

    query =
      from e in ElaunPekerja,
        order_by: [desc: e.inserted_at],
        offset: ^offset,
        limit: ^per_page

    data =
      query
      |> Repo.all()
      |> Repo.preload(maklumat_pekerja: :user)

    total_count = Repo.aggregate(ElaunPekerja, :count, :id)

    %{
      data: data,
      page: page,
      per_page: per_page,
      total_count: total_count,
      total_pages: div(total_count + per_page - 1, per_page)
    }
  end

  # -------------------------
  # PAGINATION UNTUK ELAUN MENGIKUT PEKERJA
  # -------------------------
  def list_elaun_pekerja_by_pekerja_paginated(maklumat_pekerja_id, page \\ 1, per_page \\ 5) do
    offset = (page - 1) * per_page

    query =
      from e in ElaunPekerja,
        where: e.maklumat_pekerja_id == ^maklumat_pekerja_id,
        order_by: [desc: e.inserted_at],
        offset: ^offset,
        limit: ^per_page

    data =
      query
      |> Repo.all()
      |> Repo.preload([:item_elaun_pekerja, maklumat_pekerja: :user])

    total_count =
      from(e in ElaunPekerja, where: e.maklumat_pekerja_id == ^maklumat_pekerja_id)
      |> Repo.aggregate(:count, :id)

    %{
      data: data,
      page: page,
      per_page: per_page,
      total_count: total_count,
      total_pages: div(total_count + per_page - 1, per_page) # manual ceil_div
    }
  end

  # DROPDOWN FILTER PANEL PEKERJA TABLE ELAUN_PEKERJA
  @doc """
  List elaun pekerja mengikut maklumat_pekerja_id, optional status filter, with pagination.

  status: "all" (tiada filter) atau status string yang sesuai dengan nilai di DB.
  """
  def list_elaun_pekerja_by_pekerja_paginated_filtered(maklumat_pekerja_id, status \\ "all", page \\ 1, per_page \\ 5) do
    offset = (page - 1) * per_page

    base =
      from e in ElaunPekerja,
        where: e.maklumat_pekerja_id == ^maklumat_pekerja_id

    base =
      case status do
        nil ->
          base

        "all" ->
          base

        s when is_binary(s) and s != "" ->
          from e in base,
            where: e.status_permohonan == ^s

        _ ->
          base
      end

    query =
      from e in base,
        order_by: [desc: e.inserted_at],
        offset: ^offset,
        limit: ^per_page

    data =
      query
      |> Repo.all()
      |> Repo.preload([:item_elaun_pekerja, maklumat_pekerja: :user])

    total_count =
      base
      |> exclude(:preload)
      |> exclude(:order_by)
      |> Repo.aggregate(:count, :id)

    %{
      data: data,
      page: page,
      per_page: per_page,
      total_count: total_count,
      total_pages: div(total_count + per_page - 1, per_page)
    }
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

  def search_elaun_pekerja(query, page, per_page) do
    offset = (page - 1) * per_page

    base_query =
      from e in ElaunPekerja,
        join: m in assoc(e, :maklumat_pekerja),
        join: u in assoc(m, :user),
        where: ilike(u.full_name, ^"%#{query}%"),
        preload: [maklumat_pekerja: {m, user: u}],
        order_by: [desc: e.inserted_at],
        offset: ^offset,
        limit: ^per_page

    data = Repo.all(base_query)

    total_count =
      from(e in ElaunPekerja,
        join: m in assoc(e, :maklumat_pekerja),
        join: u in assoc(m, :user),
        where: ilike(u.full_name, ^"%#{query}%")
      )
      |> Repo.aggregate(:count, :id)

    %{
      data: data,
      page: page,
      per_page: per_page,
      total_count: total_count,
      total_pages: div(total_count + per_page - 1, per_page)
    }
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

  # -------------------------
  # PAGINATION UNTUK ITEM ELAUN PEKERJA
  # -------------------------
  def list_item_elaun_pekerja_paginated(page \\ 1, per_page \\ 5) do
    offset = (page - 1) * per_page

    query =
      from i in ItemElaunPekerja,
        order_by: [desc: i.inserted_at],
        offset: ^offset,
        limit: ^per_page

    data =
      query
      |> Repo.all()
      |> Repo.preload(elaun_pekerja: [maklumat_pekerja: :user])

    total_count = Repo.aggregate(ItemElaunPekerja, :count)

    %{
      data: data,
      page: page,
      per_page: per_page,
      total_count: total_count,
      total_pages: div(total_count + per_page - 1, per_page) # ✅ manual ceil
    }
  end

  def list_item_elaun_pekerja_by_user_paginated(user_id, page \\ 1, per_page \\ 5) do
    offset = (page - 1) * per_page

    query =
      from i in ItemElaunPekerja,
        join: e in assoc(i, :elaun_pekerja),
        join: m in assoc(e, :maklumat_pekerja),
        where: m.user_id == ^user_id,
        order_by: [desc: i.inserted_at],
        offset: ^offset,
        limit: ^per_page,
        preload: [elaun_pekerja: [maklumat_pekerja: :user]]

    data = Repo.all(query)

    total_count =
      from(i in ItemElaunPekerja,
        join: e in assoc(i, :elaun_pekerja),
        join: m in assoc(e, :maklumat_pekerja),
        where: m.user_id == ^user_id
      )
      |> Repo.aggregate(:count, :id)

    %{
      data: data,
      page: page,
      per_page: per_page,
      total_count: total_count,
      total_pages: div(total_count + per_page - 1, per_page) # ceil div
    }
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
    |> case do
      {:ok, item} ->
        elaun = Repo.get!(ElaunPekerja, item.elaun_pekerja_id)
        recalc_jumlah_keseluruhan(elaun)
        {:ok, item}

      error ->
        error
    end
  end

  def update_item_elaun_pekerja(%ItemElaunPekerja{} = item, attrs) do
    item
    |> ItemElaunPekerja.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, item} ->
        elaun = Repo.get!(ElaunPekerja, item.elaun_pekerja_id)
        recalc_jumlah_keseluruhan(elaun)
        {:ok, item}

      error ->
        error
    end
  end

  def delete_item_elaun_pekerja(%ItemElaunPekerja{} = item) do
    Repo.delete(item)
    |> case do
      {:ok, item} ->
        elaun = Repo.get!(ElaunPekerja, item.elaun_pekerja_id)
        recalc_jumlah_keseluruhan(elaun)
        {:ok, item}

      error ->
        error
    end
  end

  def change_item_elaun_pekerja(%ItemElaunPekerja{} = item, attrs \\ %{}) do
    ItemElaunPekerja.changeset(item, attrs)
  end

  # Panel Admin
  def search_item_elaun_pekerja(query, page \\ 1, per_page \\ 5) do
    offset = (page - 1) * per_page

    q =
      from i in ItemElaunPekerja,
        where:
          ilike(i.kenyataan_tuntutan, ^"%#{query}%") or
            ilike(i.keterangan, ^"%#{query}%"),
        order_by: [desc: i.inserted_at],
        offset: ^offset,
        limit: ^per_page,
        preload: [elaun_pekerja: [maklumat_pekerja: :user]]

    data = Repo.all(q)

    total_count =
      from(i in ItemElaunPekerja,
        where:
          ilike(i.kenyataan_tuntutan, ^"%#{query}%") or
            ilike(i.keterangan, ^"%#{query}%")
      )
      |> Repo.aggregate(:count, :id)

    %{
      data: data,
      page: page,
      per_page: per_page,
      total_count: total_count,
      total_pages: div(total_count + per_page - 1, per_page)
    }
  end

 # -------------------------
  # Panel pekerja (compatible overloads)
  # -------------------------

  # 2-arity convenience: search with defaults (query only)
  def search_item_elaun_pekerja_by_user(user_id, query) do
    # default: no date, page 1, per_page 5
    search_item_elaun_pekerja_by_user(user_id, query, nil, 1, 5)
  end

  # 4-arity backward compatibility: (user_id, query, page, per_page)
  def search_item_elaun_pekerja_by_user(user_id, query, page, per_page) when is_integer(page) and is_integer(per_page) do
    # delegate to full 5-arity with date = nil
    search_item_elaun_pekerja_by_user(user_id, query, nil, page, per_page)
  end

  # 5-arity full implementation: (user_id, query, date, page, per_page)
  def search_item_elaun_pekerja_by_user(user_id, query, date, page, per_page) do
    offset = (page - 1) * per_page

    base =
      from i in ItemElaunPekerja,
        join: e in assoc(i, :elaun_pekerja),
        join: m in assoc(e, :maklumat_pekerja),
        where: m.user_id == ^user_id

    base =
      if is_binary(query) and String.trim(query) != "" do
        like = "%#{String.replace(query, "%", "\\%")}%"

        from i in base,
          where:
            ilike(i.kenyataan_tuntutan, ^like) or
              ilike(i.keterangan, ^like)
      else
        base
      end

    base =
      if date do
        # tarikh_tuntutan is :date in schema, so direct comparison is fine
        from i in base,
          where: i.tarikh_tuntutan == ^date
      else
        base
      end

    q =
      from i in base,
        order_by: [desc: i.inserted_at],
        offset: ^offset,
        limit: ^per_page,
        preload: [elaun_pekerja: [maklumat_pekerja: :user]]

    data = Repo.all(q)

    total_count =
      base
      |> exclude(:preload)
      |> exclude(:order_by)
      |> Repo.aggregate(:count, :id)

    %{
      data: data,
      page: page,
      per_page: per_page,
      total_count: total_count,
      total_pages: div(total_count + per_page - 1, per_page)
    }
  end


  # -------------------------
  # JUMLAH KESELURUHAN AUTO
  # -------------------------

  def recalc_jumlah_keseluruhan(%ElaunPekerja{} = elaun) do
    total =
      from(i in ItemElaunPekerja,
        where:
          i.elaun_pekerja_id == ^elaun.id and
            i.tarikh_tuntutan >= ^elaun.tarikh_mula and
            i.tarikh_tuntutan <= ^elaun.tarikh_akhir,
        select: coalesce(sum(i.jumlah), 0)
      )
      |> Repo.one()

    update_elaun_pekerja(elaun, %{jumlah_keseluruhan: total})
  end

  # -------------------------
  # HELPER FUNCTIONS
  # -------------------------
  def preload_elaun(elaun) do
    Repo.preload(elaun, [:item_elaun_pekerja, maklumat_pekerja: :user])
  end
end

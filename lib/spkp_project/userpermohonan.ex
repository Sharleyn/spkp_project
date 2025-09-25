defmodule SpkpProject.Userpermohonan do
  import Ecto.Query, warn: false

  alias SpkpProject.Repo
  alias SpkpProject.Userpermohonan.Userpermohonan


  # Senarai permohonan ikut user + pagination
  def list_user_applications(user_id, filter \\ "Semua Keputusan", page \\ 1, per_page \\ 10) do
    query =
      from(p in SpkpProject.Userpermohonan.Userpermohonan,
        where: p.user_id == ^user_id,
        join: k in assoc(p, :kursus),
        preload: [kursus: k],
        order_by: [desc: p.inserted_at]
      )

    query =
      case filter do
        "Diterima" -> from p in query, where: p.status == "Diterima"
        "Dalam Proses" -> from p in query, where: p.status == "Dalam Proses"
        "Ditolak" -> from p in query, where: p.status == "Ditolak"
        _ -> query
      end

    results =
      query
      |> limit(^(per_page + 1))
      |> offset(^(per_page * (page - 1)))
      |> SpkpProject.Repo.all()

    has_more = length(results) > per_page
    {Enum.take(results, per_page), has_more}
  end

  # Cari kursus ikut nama + pagination
  def search_user_applications(user_id, term, filter \\ "Semua Keputusan", page \\ 1, per_page \\ 10) do
    query =
      from(p in SpkpProject.Userpermohonan.Userpermohonan,
        where: p.user_id == ^user_id,
        join: k in assoc(p, :kursus),
        preload: [kursus: k],
        where: ilike(k.nama_kursus, ^"%#{term}%"),
        order_by: [desc: p.inserted_at]
      )

    query =
      case filter do
        "Diterima" -> from p in query, where: p.status == "Diterima"
        "Dalam Proses" -> from p in query, where: p.status == "Dalam Proses"
        "Ditolak" -> from p in query, where: p.status == "Ditolak"
        _ -> query
      end

    results =
      query
      |> limit(^(per_page + 1))
      |> offset(^(per_page * (page - 1)))
      |> SpkpProject.Repo.all()

    has_more = length(results) > per_page
    {Enum.take(results, per_page), has_more}
  end

  def create_application(user_id, kursus_id) do
    %Userpermohonan{}
    |> Userpermohonan.changeset(%{
      user_id: user_id,
      kursus_id: kursus_id,
      status: "Dalam Proses"
    })
    |> Repo.insert()
  end

  def get_user_stats(user_id) do
    query =
      from p in SpkpProject.Userpermohonan.Userpermohonan,
        where: p.user_id == ^user_id

    all = Repo.aggregate(query, :count, :id)

    diterima =
      query
      |> where([p], p.status == "Diterima")
      |> Repo.aggregate(:count, :id)

    ditolak =
      query
      |> where([p], p.status == "Ditolak")
      |> Repo.aggregate(:count, :id)

    dalam_proses =
      query
      |> where([p], p.status == "Dalam Proses")
      |> Repo.aggregate(:count, :id)

    %{
      total: all,
      diterima: diterima,
      ditolak: ditolak,
      dalam_proses: dalam_proses
    }
  end

  # Padam permohonan
  def delete_application(id) do
    case Repo.get(Userpermohonan, id) do
      nil -> {:error, :not_found}
      permohonan -> Repo.delete(permohonan)
    end
  end

    #JUMLAH PERMOHONAN TERKINI DAN TARIKH TUTUP PERMOHONAN
  def list_latest_applications_summary(limit \\ 5) do

      query =
        from p in Userpermohonan,
          join: k in assoc(p, :kursus),
          group_by: [k.id, k.nama_kursus, k.tarikh_tutup],
          select: %{
            kursus: k.nama_kursus,
            tarikh_tutup: k.tarikh_tutup,
            jumlah_permohonan: count(p.id)
          },
          order_by: [desc: k.inserted_at],
          limit: ^limit

      Repo.all(query)
    end
  end

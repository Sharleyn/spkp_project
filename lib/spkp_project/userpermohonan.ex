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

  # Padam permohonan
  def delete_application(id) do
    case Repo.get(Userpermohonan, id) do
      nil -> {:error, :not_found}
      permohonan -> Repo.delete(permohonan)
    end
  end
end

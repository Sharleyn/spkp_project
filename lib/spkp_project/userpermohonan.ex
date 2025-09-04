defmodule SpkpProject.Userpermohonan do
  import Ecto.Query, warn: false
  alias SpkpProject.Repo
  alias SpkpProject.Userpermohonan.Userpermohonan

  # Senarai permohonan ikut user
  def list_user_applications(user_id, filter \\ "Semua Keputusan") do
    query =
      from p in Userpermohonan,
        where: p.user_id == ^user_id,
        join: k in assoc(p, :kursus),
        preload: [kursus: k],
        order_by: [desc: p.inserted_at]

    query =
      case filter do
        "Diterima" -> from p in query, where: p.status == "Diterima"
        "Dalam Proses" -> from p in query, where: p.status == "Dalam Proses"
        "Ditolak" -> from p in query, where: p.status == "Ditolak"
        _ -> query
      end

    Repo.all(query)
  end

  # Cari kursus ikut nama
  def search_user_applications(user_id, term) do
    from(p in Userpermohonan,
      join: k in assoc(p, :kursus),
      where: p.user_id == ^user_id and ilike(k.nama_kursus, ^"%#{term}%"),
      preload: [kursus: k],
      order_by: [desc: p.inserted_at]
    )
    |> Repo.all()
  end

  # Padam permohonan
  def delete_application(id) do
    case Repo.get(Userpermohonan, id) do
      nil -> {:error, :not_found}
      permohonan -> Repo.delete(permohonan)
    end
  end
end

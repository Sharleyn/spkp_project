defmodule SpkpProject.Accounts.UserProfile do
  use Ecto.Schema

  import Ecto.Changeset

  schema "user_profiles" do
    field :ic, :string
    field :age, :integer
    field :gender, :string
    field :phone_number, :string
    field :address, :string
    field :district, :string
    field :education, :string
    field :ic_attachment, :string
    field :tarikh_lahir, :date

    belongs_to :user, SpkpProject.Accounts.User

    timestamps()
  end

  # --- Senarai pilihan ---
  @gender_options ["Lelaki", "Perempuan"]

  @district_options [
    "Beaufort", "Beluran", "Keningau", "Kota Belud", "Kota Kinabalu", "Kota Marudu", "Kuala Penyu", "Kudat", "Kunak", "Lahad Datu",
    "Nabawan", "Papar", "Penampang", "Pitas", "Putatan", "Ranau", "Sandakan", "Semporna", "Sipitang", "Tambunan",
    "Tawau", "Tenom", "Tongod", "Tuaran"
  ]

  @education_options [
    "SPM", "STPM", "Diploma", "Ijazah Sarjana Muda", "Ijazah Sarjana", "PhD",
    "Sijil Kemahiran"
  ]

  # --- Expose sebagai fungsi supaya boleh dipanggil di LiveView ---
  def gender_options, do: @gender_options
  def district_options, do: @district_options
  def education_options, do: @education_options

    @doc false
  def changeset(user_profile, attrs) do
    user_profile
    |> cast(attrs, [:user_id, :ic, :gender, :phone_number, :address, :district, :education, :ic_attachment, :tarikh_lahir])
    |> validate_required([:user_id, :ic, :gender, :phone_number, :address, :district, :education, :tarikh_lahir])
    |> validate_inclusion(:gender, @gender_options)
    |> validate_inclusion(:district, @district_options)
    |> validate_inclusion(:education, @education_options)
    |> unique_constraint(:user_id)
  end

  # ✅ Helper untuk kira umur
  def kira_umur(nil), do: nil
  def kira_umur(tarikh_lahir) do
    today = Date.utc_today()
    years = today.year - tarikh_lahir.year

    # adjust kalau birthday belum sampai tahun ni
    if {today.month, today.day} < {tarikh_lahir.month, tarikh_lahir.day} do
      years - 1
    else
      years
    end
  end

end

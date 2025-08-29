# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SpkpProject.Repo.insert!(%SpkpProject.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias SpkpProject.Repo
alias SpkpProject.Accounts.User
alias Pbkdf2
import Ecto.Changeset

admin_email = "admin@example.com"
admin_password = "supersecretpassword"

user =
  Repo.get_by(User, email: admin_email) ||
    %User{email: admin_email}

user
|> change(%{
  full_name: "Super Admin",
  hashed_password: Pbkdf2.hash_pwd_salt(admin_password),
  # 🚀 seed terus jadikan admin
  role: "admin",
  confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)
})
|> Repo.insert_or_update!()

IO.puts("✅ Admin ensured: #{admin_email} | password=#{admin_password}")

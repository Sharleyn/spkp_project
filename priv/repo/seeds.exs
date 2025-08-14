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

unless Repo.get_by(User, email: "admin@gmail.com") do
params = %{
email: "admin@gmail.com",
password: "123456789qwert"
}
%User{}
|> User.registration_changeset(params)
|> Ecto.Changeset.change(%{
role: "admin",
confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)
})
|> Repo.insert!()
IO.puts("
 ✅
 Admin user created!")
end

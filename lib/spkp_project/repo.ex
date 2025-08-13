defmodule SpkpProject.Repo do
  use Ecto.Repo,
    otp_app: :spkp_project,
    adapter: Ecto.Adapters.Postgres
end

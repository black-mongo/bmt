defmodule BmtAdmin.Repo do
  use Ecto.Repo,
    otp_app: :bmt_admin,
    adapter: Ecto.Adapters.Postgres
end

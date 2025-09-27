defmodule Install.Repo do
  use Ecto.Repo,
    otp_app: :install,
    adapter: Ecto.Adapters.Postgres
end

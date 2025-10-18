defmodule Exdraw.Repo do
  use Ecto.Repo,
    otp_app: :exdraw,
    adapter: Ecto.Adapters.Postgres
end

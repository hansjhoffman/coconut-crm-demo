defmodule Coconut.Repo do
  use Ecto.Repo,
    otp_app: :coconut,
    adapter: Ecto.Adapters.Postgres
end

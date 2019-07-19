defmodule Vocial.Repo do
  use Ecto.Repo,
    otp_app: :vocial,
    adapter: Ecto.Adapters.Postgres
end

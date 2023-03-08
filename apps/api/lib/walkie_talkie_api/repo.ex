defmodule WalkieTalkieApi.Repo do
  use Ecto.Repo,
    otp_app: :walkie_talkie_api,
    adapter: Ecto.Adapters.Postgres
end

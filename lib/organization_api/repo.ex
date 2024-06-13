defmodule OrganizationApi.Repo do
  use Ecto.Repo,
    otp_app: :organization_api,
    adapter: Ecto.Adapters.Postgres
end

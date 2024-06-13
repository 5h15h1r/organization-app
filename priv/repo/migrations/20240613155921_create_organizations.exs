defmodule OrganizationApi.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :logo_url, :string
      add :configurations, :map

      timestamps(type: :utc_datetime)
    end
  end
end

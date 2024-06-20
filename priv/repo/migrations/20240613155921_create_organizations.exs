defmodule OrganizationApi.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :logo_url, :string
      add :configurations, :map
      add :is_active, :boolean, default: true
      timestamps(type: :utc_datetime)
    end

    create index(:organizations, [:is_active])
  end
end

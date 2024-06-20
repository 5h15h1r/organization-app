defmodule OrganizationApi.Repo.Migrations.CreateVendors do
  use Ecto.Migration

  def change do
    create table(:vendors, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :phone, :string
      add :email, :string
      add :organization_id, references(:organizations, on_delete: :nothing, type: :binary_id)
      add :is_active, :boolean, default: true, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:vendors, [:name])
    create index(:vendors, [:organization_id])
    create index(:vendors,[:is_active])
  end
end

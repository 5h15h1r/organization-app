defmodule OrganizationApi.Repo.Migrations.CreateAuditLog do
  use Ecto.Migration

  def change do
    create table(:audit_logs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :organization_id, references(:organizations, type: :binary_id, on_delete: :delete_all)
      add :table_name, :string, null: false
      add :action, :string
      add :record_id, :binary_id, null: false
      add :old_data, :map
      add :new_data, :map
      add :ip_address, :string
      add :user_agent, :string

      timestamps(type: :utc_datetime)
    end

    create index(:audit_logs, [:organization_id])
    create index(:audit_logs, [:table_name])
    create index(:audit_logs, [:action])
    create index(:audit_logs, [:record_id])
  end
end

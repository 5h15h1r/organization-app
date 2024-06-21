defmodule OrganizationApi.AuditLogs.AuditLog do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "audit_logs" do
    field :table_name, :string
    field :action, :string
    field :record_id, :binary_id
    field :old_data, :map
    field :new_data, :map
    field :ip_address, :string
    field :user_agent, :string

    belongs_to :organization, OrganizationApi.Organizations.Organization

    timestamps(type: :utc_datetime)
  end

  def changeset(audit_log, attrs) do
    audit_log
    |> cast(attrs, [:organization_id, :table_name, :action, :record_id, :old_data, :new_data, :ip_address, :user_agent])
    |> validate_required([:organization_id, :table_name, :action, :record_id])
  end
end

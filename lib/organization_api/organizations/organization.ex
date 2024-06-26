defmodule OrganizationApi.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "organizations" do
    field :name, :string
    field :logo_url, :string
    field :configurations, :map
    field :is_active, :boolean, default: true
    has_many :vendors , OrganizationApi.Vendors.Vendor
    has_many :audit_logs, OrganizationApi.AuditLogs.AuditLog
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :logo_url, :configurations])
    |> validate_required([:name, :logo_url])
  end
end

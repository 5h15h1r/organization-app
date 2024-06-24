defmodule OrganizationApi.AuditLogFixtures do
  alias OrganizationApi.AuditLogs
  alias OrganizationApi.OrganizationsFixtures
  # @valid_attrs %{table_name: "organizations", action: "create", record_id: "some-uuid", organization_id: "org-uuid"}
  def audit_log_fixture(attrs \\ %{}) do
    organization = OrganizationsFixtures.organization_fixture()
    {:ok, audit_log} =
      attrs
      |> Enum.into(%{
        table_name: "organizations",
        organization_id: organization.id,
        record_id: organization.id,
        action: "update",
        old_data: %{},
        new_data: %{"name" => "Jane Doe"},
        ip_address: "default ip_address",
        user_agent: "default user_agent"
      })
      |> AuditLogs.create_audit_log()

    audit_log
  end
end

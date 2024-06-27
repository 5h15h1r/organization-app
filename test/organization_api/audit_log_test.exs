defmodule OrganizationApi.AuditLogsTest do
  use OrganizationApi.DataCase

  alias OrganizationApi.AuditLogs
  alias OrganizationApi.AuditLogs.AuditLog
  import OrganizationApi.AuditLogFixtures

  @invalid_attrs %{table_name: nil, action: nil, record_id: nil, organization_id: nil}

  describe "audit_logs" do
    test "create_audit_log/1 with valid data creates a audit_log" do
      valid_attrs = %{
        table_name: "organizations",
        action: "update",
        old_data: %{"name" => "John Doe"},
        new_data: %{"name" => "Jane Doe"},
        ip_address: "default ip_address",
        user_agent: "default user_agent",
        organization_id: audit_log_fixture().organization_id,
        record_id: audit_log_fixture().record_id
      }
      assert {:ok, %AuditLog{} = audit_log} = AuditLogs.create_audit_log(valid_attrs)
      assert audit_log.table_name == "organizations"
      assert audit_log.action == :update
      assert audit_log.old_data == %{"name" => "John Doe"}
      assert audit_log.new_data == %{"name" => "Jane Doe"}
      assert audit_log.ip_address == "default ip_address"
      assert audit_log.user_agent == "default user_agent"
    end

    test "create_audit_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AuditLogs.create_audit_log(@invalid_attrs)
    end

    test "list_audit_log/0 returns all audit_logs" do
      audit_log = audit_log_fixture()
      assert AuditLogs.list_audit_log() == [audit_log]
    end

    test "filter_audit_logs_by_table/1 returns audit_logs for a specific table" do
      audit_log1 = audit_log_fixture(%{table_name: "organizations"})
      audit_log2 = audit_log_fixture(%{table_name: "vendors"})

      assert AuditLogs.filter_audit_logs_by_table("organizations") == [audit_log1]
      assert AuditLogs.filter_audit_logs_by_table("vendors") == [audit_log2]
    end

    test "filter_audit_logs_by_action/1 returns audit_logs for a specific action" do
      audit_log1 = audit_log_fixture(%{action: "create"})
      audit_log2 = audit_log_fixture(%{action: "update"})

      assert AuditLogs.filter_audit_logs_by_action("create") == [audit_log1]
      assert AuditLogs.filter_audit_logs_by_action("update") == [audit_log2]

    end
  end
end

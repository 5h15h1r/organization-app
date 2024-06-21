defmodule OrganizationApiWeb.AuditLogJSON do
  alias OrganizationApi.AuditLogs.AuditLog

  @doc """
  Renders a list of audit logs.
  """
  def index(%{audit_logs: audit_logs}) do
    Enum.map(audit_logs, &data/1)
  end

  defp data(%AuditLog{} = audit_log) do
    %{
      id: audit_log.id,
      organization_id: audit_log.organization_id,
      table_name: audit_log.table_name,
      action: audit_log.action,
      record_id: audit_log.record_id,
      old_data: audit_log.old_data,
      new_data: audit_log.new_data,
      ip_address: audit_log.ip_address,
      user_agent: audit_log.user_agent,
      inserted_at: audit_log.inserted_at,
      updated_at: audit_log.updated_at
    }
  end
end

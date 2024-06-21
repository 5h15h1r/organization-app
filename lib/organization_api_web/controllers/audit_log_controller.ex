defmodule OrganizationApiWeb.AuditLogController do
  use OrganizationApiWeb, :controller
  alias OrganizationApi.AuditLogs

  def index(conn, _params) do
    audit_logs = AuditLogs.list_audit_log()
    render(conn, :index, audit_logs: audit_logs)
  end

  def filter_by_table(conn, %{"table_name" => table_name}) do
    audit_logs = AuditLogs.filter_audit_logs_by_table(table_name)
    render(conn, :index, audit_logs: audit_logs)
  end

  def filter_by_action(conn, %{"action" => action}) do
    audit_logs = AuditLogs.filter_audit_logs_by_action(action)
    render(conn, :index, audit_logs: audit_logs)
  end
end

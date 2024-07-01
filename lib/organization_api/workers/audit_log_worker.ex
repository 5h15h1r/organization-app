defmodule OrganizationApi.Workers.AuditLogWorker do
  use Oban.Worker, queue: :audit_logs

  alias OrganizationApi.AuditLogs

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    AuditLogs.create_audit_log(args)
  end
end

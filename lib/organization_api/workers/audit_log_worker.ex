defmodule OrganizationApi.Workers.AuditLogWorker do
  use Oban.Worker, queue: :audit_logs

  alias OrganizationApi.AuditLogs.AuditLog
  alias OrganizationApi.Repo

  @impl Oban.Worker
  def perform(%Oban.Job{args: attrs}) do
    %AuditLog{}
    |> AuditLog.changeset(attrs)
    |> Repo.insert()

  end
end

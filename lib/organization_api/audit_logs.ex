defmodule OrganizationApi.AuditLogs do
    @moduledoc """
  The Audit Log context.
  """
  import Ecto.Query, warn: false

  alias OrganizationApi.Repo
  alias OrganizationApi.AuditLogs.AuditLog
  alias OrganizationApi.Workers.AuditLogWorker

  @doc """
  Create audti log .

  ## Examples

      iex> create_audit_log()
      [%Audtit{}, ...]

  """
  def create_audit_log(attrs \\ %{}) do
    attrs
    |> AuditLogWorker.new()
    |> Oban.insert()
  end

  def list_audit_log do
    AuditLog
    |> Repo.all()
  end

  def filter_audit_logs_by_table(table_name) do
    AuditLog
    |> where(table_name: ^table_name)
    |> Repo.all()
  end

  def filter_audit_logs_by_action(action) do
    AuditLog
    |> where(action: ^action)
    |> Repo.all()
  end
end

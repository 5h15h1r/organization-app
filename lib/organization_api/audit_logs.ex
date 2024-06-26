defmodule OrganizationApi.AuditLogs do
    @moduledoc """
  The Audit Log context.
  """
  import Ecto.Query, warn: false

  alias OrganizationApi.Repo
  alias OrganizationApi.AuditLogs.AuditLog
  alias OrganizationApi.Workers.AuditLogWorker

  @doc """
  Create an audit log .

  ## Examples

      iex> create_audit_log(%{action: "create", table_name: "organizations", new_data: %{name: "Org1"}, old_data: nil})
      [%AuditLog{}, ...]

  """
  def create_audit_log(attrs \\ %{}) do
    attrs
    |> AuditLogWorker.new()
    |> Oban.insert()
  end

  @doc """
  Lists all audit logs.

  ## Examples

      iex> list_audit_log()
      [%AuditLog{}, ...]

  """
  def list_audit_log do
    AuditLog
    |> Repo.all()
  end


  @doc """
  Filters audit logs by table name.

  ## Examples

      iex> filter_audit_logs_by_table("organizations")
      [%AuditLog{}, ...]

  """
  def filter_audit_logs_by_table(table_name) do
    AuditLog
    |> where(table_name: ^table_name)
    |> Repo.all()
  end

@doc """
  Filters audit logs by action.

  ## Examples

      iex> filter_audit_logs_by_action("create")
      [%AuditLog{}, ...]

  """
  def filter_audit_logs_by_action(action) do
    AuditLog
    |> where(action: ^action)
    |> Repo.all()
  end
end

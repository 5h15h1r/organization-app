defmodule OrganizationApiWeb.AuditLogPlug do
  import Plug.Conn
  alias OrganizationApi.AuditLogHelper

  def init(options), do: options

  def call(conn, opts) do
    register_before_send(conn, &log_action(&1, opts))
  end

  def log_action(conn, opts) do
    action = to_string(conn.private.phoenix_action)
    resource_name = Keyword.fetch!(opts, :resource)
    resource = conn.assigns[resource_name]
    if resource && action in ["create", "update", "delete"] do
      record_id = Keyword.get(opts, :record_id, :id)
      org_id = conn.assigns[:org_id]
      table_name = Keyword.get(opts, :table_name, to_string(resource_name) <> "s")

      new_data = conn.assigns[:audit_new_data] ||
                 (if action == "delete", do: "", else: AuditLogHelper.struct_to_map(resource))
      old_data = conn.assigns[:audit_old_data]

      AuditLogHelper.create_audit_log(
        conn,
        org_id,
        Map.get(resource, record_id),
        table_name,
        action,
        new_data,
        old_data
      )
    end

    conn
  end
end

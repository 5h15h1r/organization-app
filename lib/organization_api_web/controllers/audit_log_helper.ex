defmodule OrganizationApi.AuditLogHelper do
  alias OrganizationApi.AuditLogs
  alias OrganizationApi.AuditLogs.AuditLog
  def create_audit_log(conn, organization_id, record_id, table_name, action, new_data, old_data \\ nil) do
    audit_params = %{
      organization_id: organization_id,
      table_name: table_name,
      action: action,
      record_id: record_id,
      new_data: new_data,
      old_data: old_data,
      ip_address: to_string(:inet_parse.ntoa(conn.remote_ip)),
      user_agent: get_user_agent(conn)
    }

    case AuditLogs.create_audit_log(audit_params) do
      {:ok, %AuditLog{}}->
        IO.puts("Audit Log created")
      {:error, reason} ->
        IO.puts("Failed to generate Audit Log : #{reason}")
        :error
    end
  end

  def struct_to_map(struct) do
    associations = struct.__struct__.__schema__(:associations)
    struct
    |> Map.from_struct()
    |> Map.drop([:__meta__,  :is_active, :inserted_at, :updated_at | associations])
  end

  def get_user_agent(conn) do
    case Plug.Conn.get_req_header(conn, "user-agent") do
      [user_agent] -> user_agent
      _ -> "Unknown"
    end
  end
  def get_changed_data(data1, data2) do
    {changed_data1, changed_data2} = compare_maps(data1, data2)
    {changed_data1, changed_data2}
  end

  defp compare_maps(map1, map2) do
    Enum.reduce(map1, {%{}, %{}}, fn {k, v}, {acc1, acc2} ->
      case Map.get(map2, k) do
        ^v ->
          {acc1, acc2}

        %{} = sub_map2 when is_map(v) ->
          {sub_acc1, sub_acc2} = compare_maps(v, sub_map2)
          if map_size(sub_acc1) > 0 do
            {Map.put(acc1, k, sub_acc1), Map.put(acc2, k, sub_acc2)}
          else
            {acc1, acc2}
          end

        other_value ->
          {Map.put(acc1, k, v), Map.put(acc2, k, other_value)}
      end
    end)
  end


end

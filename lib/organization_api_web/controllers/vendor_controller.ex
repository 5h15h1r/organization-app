defmodule OrganizationApiWeb.VendorController do
  use OrganizationApiWeb, :controller

  alias OrganizationApi.{Vendors,AuditLogs}
  alias OrganizationApi.Vendors.Vendor
  alias OrganizationApi.AuditLogs.AuditLog

  action_fallback OrganizationApiWeb.FallbackController

  def index(conn, _params) do
    vendors = Vendors.list_vendors()
    render(conn, :index, vendors: vendors)
  end

  def create(conn, %{"vendor" => vendor_params}) do
    with {:ok, %Vendor{} = vendor} <- Vendors.create_vendor(vendor_params) do
      audit_params = %{
        organization_id: vendor.organization_id,
        table_name: "vendors",
        action: "create",
        record_id: vendor.id,
        new_data: struct_to_map(vendor),
      }
      with {:ok, %AuditLog{}} <- AuditLogs.create_audit_log(audit_params) do
        IO.puts("Audit Log generated")
      end

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/vendors/#{vendor}")
      |> render(:show, vendor: vendor)
    end
  end

  def show(conn, %{"id" => id}) do
    vendor = Vendors.get_vendor!(id)
    render(conn, :show, vendor: vendor)
  end

  def update(conn, %{"id" => id, "vendor" => vendor_params}) do
    old_vendor = Vendors.get_vendor!(id)

    with {:ok, %Vendor{} = vendor} <- Vendors.update_vendor(old_vendor, vendor_params) do
      audit_params = %{
          organization_id: vendor.organization_id,
          table_name: "vendors",
          action: "update",
          record_id: vendor.id,
          new_data: struct_to_map(vendor),
          old_data: struct_to_map(old_vendor)
        }
        with {:ok, %AuditLog{}} <- AuditLogs.create_audit_log(audit_params) do
          IO.puts("Audit Log generated")
        end
      render(conn, :show, vendor: vendor)
    end
  end

  def delete(conn, %{"id" => id}) do
    vendor = Vendors.get_vendor!(id)

    with {:ok, %Vendor{}} <- Vendors.delete_vendor(vendor) do
      audit_params = %{
        organization_id: vendor.organization_id,
        table_name: "vendors",
        action: "delete",
        record_id: vendor.id,
        new_data: "",
        old_data: struct_to_map(vendor)
      }
      with {:ok, %AuditLog{}} <- AuditLogs.create_audit_log(audit_params) do
        IO.puts("Audit Log generated")
      end
      send_resp(conn, :no_content, "")
    end
  end

  defp struct_to_map(vendor) do
    vendor
    |> Map.from_struct()
    |> Map.drop([:organization, :__meta__, :is_active, :updated_at, :inserted_at])
  end

end

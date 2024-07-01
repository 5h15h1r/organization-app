defmodule OrganizationApiWeb.VendorController do
  use OrganizationApiWeb, :controller

  alias OrganizationApi.Vendors
  alias OrganizationApi.Vendors.Vendor
  alias OrganizationApi.AuditLogHelper

  plug OrganizationApiWeb.AuditLogPlug, resource: :vendor, table_name: "vendors"
  action_fallback OrganizationApiWeb.FallbackController

  def index(conn, _params) do
    vendors = Vendors.list_vendors()
    render(conn, :index, vendors: vendors)
  end

  def create(conn, %{"vendor" => vendor_params}) do
    with {:ok, %Vendor{} = vendor} <- Vendors.create_vendor(vendor_params) do

      conn
      |> assign(:vendor, vendor)
      |> assign(:org_id, vendor.organization_id)
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
      new_data = AuditLogHelper.struct_to_map(vendor)
      old_data = AuditLogHelper.struct_to_map(old_vendor)
      {new_data, old_data} = AuditLogHelper.get_changed_data(new_data, old_data)
      conn
      |> assign(:vendor, vendor)
      |> assign(:org_id, vendor.organization_id)
      |> assign(:audit_new_data, new_data)
      |> assign(:audit_old_data, old_data)
      |> render(:show, vendor: vendor)
    end
  end

  def delete(conn, %{"id" => id}) do
    vendor = Vendors.get_vendor!(id)

    with {:ok, %Vendor{}} <- Vendors.delete_vendor(vendor) do
      old_data = AuditLogHelper.struct_to_map(vendor)
      conn
      |> assign(:vendor, vendor)
      |> assign(:org_id, vendor.organization_id)
      |> assign(:audit_old_data, old_data)
      |> send_resp(:no_content, "")
    end
  end
end

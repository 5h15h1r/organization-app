defmodule OrganizationApiWeb.VendorController do
  use OrganizationApiWeb, :controller

  alias OrganizationApi.Vendors
  alias OrganizationApi.Vendors.Vendor

  action_fallback OrganizationApiWeb.FallbackController

  def index(conn, _params) do
    vendors = Vendors.list_vendors()
    render(conn, :index, vendors: vendors)
  end

  def create(conn, %{"vendor" => vendor_params}) do
    with {:ok, %Vendor{} = vendor} <- Vendors.create_vendor(vendor_params) do
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
    vendor = Vendors.get_vendor!(id)

    with {:ok, %Vendor{} = vendor} <- Vendors.update_vendor(vendor, vendor_params) do
      render(conn, :show, vendor: vendor)
    end
  end

  def delete(conn, %{"id" => id}) do
    vendor = Vendors.get_vendor!(id)

    with {:ok, %Vendor{}} <- Vendors.soft_delete(vendor) do
      send_resp(conn, :no_content, "")
    end
  end
end

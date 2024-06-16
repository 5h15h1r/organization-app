defmodule OrganizationApiWeb.VendorJSON do
  alias OrganizationApi.Vendors.Vendor

  @doc """
  Renders a list of vendors.
  """
  def index(%{vendors: vendors}) do
    %{data: for(vendor <- vendors, do: data(vendor))}
  end

  @doc """
  Renders a single vendor.
  """
  def show(%{vendor: vendor}) do
    %{data: data(vendor)}
  end

  defp data(%Vendor{} = vendor) do
    %{
      id: vendor.id,
      name: vendor.name,
      phone: vendor.phone,
      email: vendor.email
    }
  end
end

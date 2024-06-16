defmodule OrganizationApi.VendorsFixtures do
  import OrganizationApi.OrganizationsFixtures
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OrganizationApi.Vendors` context.
  """

  @doc """
  Generate a unique vendor name.
  """
  def unique_vendor_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a vendor.
  """
  def vendor_fixture(attrs \\ %{}) do
    organization= organization_fixture()
    {:ok, vendor} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: unique_vendor_name(),
        phone: "some phone",
        organization_id: organization.id
      })
      |> OrganizationApi.Vendors.create_vendor()

    vendor
  end
end

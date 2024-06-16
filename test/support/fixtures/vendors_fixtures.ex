defmodule OrganizationApi.VendorsFixtures do
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
    {:ok, vendor} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: unique_vendor_name(),
        phone: "some phone"
      })
      |> OrganizationApi.Vendors.create_vendor()

    vendor
  end
end

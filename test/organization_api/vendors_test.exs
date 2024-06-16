defmodule OrganizationApi.VendorsTest do
  use OrganizationApi.DataCase

  alias OrganizationApi.Vendors

  describe "vendors" do
    alias OrganizationApi.Vendors.Vendor

    import OrganizationApi.VendorsFixtures

    @invalid_attrs %{name: nil, phone: nil, email: nil}

    setup do
      organization = OrganizationApi.OrganizationsFixtures.organization_fixture()
      {:ok, organization: organization}
    end

    test "list_vendors/0 returns all vendors",%{organization: organization} do
      vendor = vendor_fixture(%{organization_id: organization.id})
      assert Vendors.list_vendors() == [vendor]
    end

    test "get_vendor!/1 returns the vendor with given id", %{organization: organization} do
      vendor = vendor_fixture(%{organization_id: organization.id})
      assert Vendors.get_vendor!(vendor.id) == vendor
    end

    test "create_vendor/1 with valid data creates a vendor", %{organization: organization} do
      valid_attrs = %{name: "some name", phone: "some phone", email: "some email", organization_id: organization.id }

      assert {:ok, %Vendor{} = vendor} = Vendors.create_vendor(valid_attrs)
      assert vendor.name == "some name"
      assert vendor.phone == "some phone"
      assert vendor.email == "some email"
    end

    test "create_vendor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vendors.create_vendor(@invalid_attrs)
    end

    test "update_vendor/2 with valid data updates the vendor", %{organization: organization} do
      vendor = vendor_fixture()
      update_attrs = %{name: "some updated name", phone: "some updated phone", email: "some updated email", organization_id: organization.id}

      assert {:ok, %Vendor{} = vendor} = Vendors.update_vendor(vendor, update_attrs)
      assert vendor.name == "some updated name"
      assert vendor.phone == "some updated phone"
      assert vendor.email == "some updated email"
    end

    test "update_vendor/2 with invalid data returns error changeset",%{organization: organization} do
      vendor = vendor_fixture(%{organization_id: organization.id})
      assert {:error, %Ecto.Changeset{}} = Vendors.update_vendor(vendor, @invalid_attrs)
      assert vendor == Vendors.get_vendor!(vendor.id)
    end

    test "delete_vendor/1 deletes the vendor", %{organization: organization} do
      vendor = vendor_fixture(%{organization_id: organization.id})
      assert {:ok, %Vendor{}} = Vendors.delete_vendor(vendor)
      assert_raise Ecto.NoResultsError, fn -> Vendors.get_vendor!(vendor.id) end
    end

    test "change_vendor/1 returns a vendor changeset", %{organization: organization} do
      vendor = vendor_fixture(%{organization_id: organization.id})
      assert %Ecto.Changeset{} = Vendors.change_vendor(vendor)
    end
  end
end

defmodule OrganizationApiWeb.VendorControllerTest do
  use OrganizationApiWeb.ConnCase

  import OrganizationApi.VendorsFixtures
  import OrganizationApi.OrganizationsFixtures
  alias OrganizationApi.Vendors.Vendor
  alias OrganizationApi.Repo

  @create_attrs %{
    name: "some name",
    phone: "some phone",
    email: "some email"
  }
  @update_attrs %{
    name: "some updated name",
    phone: "some updated phone",
    email: "some updated email"
  }
  @invalid_attrs %{name: nil, phone: nil, email: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json"), organization: organization_fixture()}
  end

  describe "index" do
    test "lists all vendors", %{conn: conn} do
      conn = get(conn, ~p"/api/vendors")
      assert json_response(conn, 200) == []
    end
  end

  describe "create vendor" do

    test "renders vendor when data is valid", %{conn: conn, organization: organization} do
      valid_attrs = Map.put(@create_attrs, :organization_id, organization.id)

      conn = post(conn, ~p"/api/vendors", vendor: valid_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/vendors/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some email",
               "name" => "some name",
               "phone" => "some phone"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/vendors", vendor: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update vendor" do
    setup [:create_vendor]

    test "renders vendor when data is valid", %{conn: conn, vendor: %Vendor{id: id} = vendor} do
      conn = put(conn, ~p"/api/vendors/#{vendor}", vendor: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/vendors/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some updated email",
               "name" => "some updated name",
               "phone" => "some updated phone"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, vendor: vendor} do
      conn = put(conn, ~p"/api/vendors/#{vendor}", vendor: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete vendor" do
    setup [:create_vendor]

    test "deletes chosen vendor", %{conn: conn, vendor: vendor} do
      conn = delete(conn, ~p"/api/vendors/#{vendor}")
      assert response(conn, 204)

      deleted_vendor = Repo.get!(Vendor, vendor.id)
      assert deleted_vendor.is_active == false

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/vendors/#{vendor}")
      end
    end
  end

  defp create_vendor(_) do
    vendor = vendor_fixture()
    %{vendor: vendor}
  end
end

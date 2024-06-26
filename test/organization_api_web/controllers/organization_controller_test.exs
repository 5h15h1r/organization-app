defmodule OrganizationApiWeb.OrganizationControllerTest do
  use OrganizationApiWeb.ConnCase

  import OrganizationApi.OrganizationsFixtures

  alias OrganizationApi.Organizations.Organization
  alias OrganizationApi.Repo

  @create_attrs %{
    name: "some name",
    logo_url: "some logo_url",
    configurations: %{}
  }
  @update_attrs %{
    name: "some updated name",
    logo_url: "some updated logo_url",
    configurations: %{}
  }
  @invalid_attrs %{name: nil, logo_url: nil, configurations: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all organizations", %{conn: conn} do
      conn = get(conn, ~p"/api/organizations")
      assert json_response(conn, 200) == []
    end
  end

  describe "create organization" do
    test "renders organization when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/organizations", organization: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/organizations/#{id}")

      assert %{
               "id" => ^id,
               "configurations" => %{},
               "logo_url" => "some logo_url",
               "name" => "some name"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/organizations", organization: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update organization" do
    setup [:create_organization]

    test "renders organization when data is valid", %{conn: conn, organization: %Organization{id: id} = organization} do
      conn = put(conn, ~p"/api/organizations/#{organization}", organization: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/organizations/#{id}")

      assert %{
               "id" => ^id,
               "configurations" => %{},
               "logo_url" => "some updated logo_url",
               "name" => "some updated name"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, organization: organization} do
      conn = put(conn, ~p"/api/organizations/#{organization}", organization: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete organization" do
    setup [:create_organization]

    test "deletes chosen organization", %{conn: conn, organization: organization} do
      conn = delete(conn, ~p"/api/organizations/#{organization}")
      assert response(conn, 204)

      deleted_organization = Repo.get!(Organization, organization.id)
      assert deleted_organization.is_active == false
      
      assert_error_sent 404, fn ->
        get(conn, ~p"/api/organizations/#{organization}")
      end
    end
  end

  defp create_organization(_) do
    organization = organization_fixture()
    %{organization: organization}
  end
end

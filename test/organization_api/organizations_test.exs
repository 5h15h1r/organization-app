defmodule OrganizationApi.OrganizationsTest do
  use OrganizationApi.DataCase

  alias OrganizationApi.Organizations

  describe "organizations" do
    alias OrganizationApi.Organizations.Organization

    import OrganizationApi.OrganizationsFixtures

    @invalid_attrs %{name: nil, logo_url: nil, configurations: nil}

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Organizations.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Organizations.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      valid_attrs = %{name: "some name", logo_url: "some logo_url", configurations: %{}}

      assert {:ok, %Organization{} = organization} = Organizations.create_organization(valid_attrs)
      assert organization.name == "some name"
      assert organization.logo_url == "some logo_url"
      assert organization.configurations == %{}
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()
      update_attrs = %{name: "some updated name", logo_url: "some updated logo_url", configurations: %{}}

      assert {:ok, %Organization{} = organization} = Organizations.update_organization(organization, update_attrs)
      assert organization.name == "some updated name"
      assert organization.logo_url == "some updated logo_url"
      assert organization.configurations == %{}
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()
      assert {:error, %Ecto.Changeset{}} = Organizations.update_organization(organization, @invalid_attrs)
      assert organization == Organizations.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Organizations.soft_delete(organization)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Organizations.change_organization(organization)
    end
  end
end

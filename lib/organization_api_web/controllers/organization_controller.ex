defmodule OrganizationApiWeb.OrganizationController do
  use OrganizationApiWeb, :controller

  alias OrganizationApi.Organizations
  alias OrganizationApi.Organizations.Organization
  alias OrganizationApi.AuditLogHelper

  action_fallback OrganizationApiWeb.FallbackController

  def index(conn, _params) do
    organizations = Organizations.list_organizations()
    render(conn, :index, organizations: organizations)
  end

  def create(conn, %{"organization" => organization_params}) do
    with {:ok, %Organization{} = organization} <- Organizations.create_organization(organization_params) do
      new_data = AuditLogHelper.struct_to_map(organization)
      AuditLogHelper.create_audit_log(
        conn,
        organization.id,
        organization.id,
        "organizations",
        "create",
        new_data
        )
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/organizations/#{organization}")
      |> render(:show, organization: organization)
    end
  end

  def show(conn, %{"id" => id}) do
    organization = Organizations.get_organization!(id)
    render(conn, :show, organization: organization)
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    old_organization = Organizations.get_organization!(id)

    with {:ok, %Organization{} = organization} <- Organizations.update_organization(old_organization, organization_params) do
      new_data = AuditLogHelper.struct_to_map(organization)
      old_data = AuditLogHelper.struct_to_map(old_organization)
      {new_data, old_data} = AuditLogHelper.get_changed_data(new_data, old_data)

        AuditLogHelper.create_audit_log(
          conn,
          organization.id,
          organization.id,
          "organizations",
          "update",
          new_data,
          old_data
          )
      render(conn, :show, organization: organization)
    end
  end

  def delete(conn, %{"id" => id}) do
    organization = Organizations.get_organization!(id)

    with {:ok, %Organization{}} <- Organizations.delete_organization(organization) do
      old_data = AuditLogHelper.struct_to_map(organization)
      AuditLogHelper.create_audit_log(
          conn,
          organization.id,
          organization.id,
          "organizations",
          "delete",
          "",
          old_data
          )
      send_resp(conn, :no_content, "")
    end
  end
end

defmodule OrganizationApiWeb.OrganizationController do
  use OrganizationApiWeb, :controller

  alias OrganizationApi.AuditLogs.AuditLog
  alias OrganizationApi.{Organizations, AuditLogs}
  alias OrganizationApi.Organizations.Organization

  action_fallback OrganizationApiWeb.FallbackController

  def index(conn, _params) do
    organizations = Organizations.list_organizations()
    render(conn, :index, organizations: organizations)
  end

  def create(conn, %{"organization" => organization_params}) do
    with {:ok, %Organization{} = organization} <- Organizations.create_organization(organization_params) do
      audit_params = %{
        organization_id: organization.id,
        table_name: "organizations",
        action: "create",
        record_id: organization.id,
        new_data: organization_params ,
      }
      with {:ok, %AuditLog{}} <- AuditLogs.create_audit_log(audit_params) do
        IO.puts("Audit Log generated")
      end
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
      audit_params = %{
        organization_id: organization.id,
        table_name: "organizations",
        action: "update",
        record_id: organization.id,
        new_data: struct_to_map(organization),
        old_data: struct_to_map(old_organization)
      }
      with {:ok, %AuditLog{}} <- AuditLogs.create_audit_log(audit_params) do
        IO.puts("Audit Log generated")
      end
      render(conn, :show, organization: organization)
    end
  end

  def delete(conn, %{"id" => id}) do
    organization = Organizations.get_organization!(id)

    with {:ok, %Organization{}} <- Organizations.delete_organization(organization) do
      audit_params = %{
        organization_id: organization.id,
        table_name: "organizations",
        action: "delete",
        record_id: organization.id,
        new_data: "",
        old_data: struct_to_map(organization)
      }
      with {:ok, %AuditLog{}} <- AuditLogs.create_audit_log(audit_params) do
        IO.puts("Audit Log generated")
      end
      send_resp(conn, :no_content, "")
    end
  end

  defp struct_to_map(organization) do
    organization
    |> Map.from_struct()
    |> Map.drop([:vendors, :__meta__, :is_active, :updated_at, :inserted_at])
  end
end

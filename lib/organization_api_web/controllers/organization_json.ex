defmodule OrganizationApiWeb.OrganizationJSON do
  alias OrganizationApi.Organizations.Organization

  @doc """
  Renders a list of organizations.
  """
  def index(%{organizations: organizations}) do
    for(organization <- organizations, do: data(organization))
  end

  @doc """
  Renders a single organization.
  """
  def show(%{organization: organization}) do
    data(organization)
  end

  defp data(%Organization{} = organization) do
    %{
      id: organization.id,
      name: organization.name,
      logo_url: organization.logo_url,
      configurations: organization.configurations
    }
  end
end

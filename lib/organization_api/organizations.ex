defmodule OrganizationApi.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  import OrganizationApi.HandleError

  alias OrganizationApi.Repo
  alias OrganizationApi.Organizations.Organization

  @doc """
  Returns the list of organizations are active.

  ## Examples

      iex> list_organizations()
      [%Organization{}, ...]

  """
  def list_organizations do
    Organization
    |> where([o], o.is_active==true)
    |> Repo.all()
  end

  @doc """
  Gets a single organization.

  Raises `Ecto.NoResultsError` if the Organization does not exist or is soft deleted.

  ## Examples

      iex> get_organization!(123)
      %Organization{}

      iex> get_organization!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organization!(id) do
    Organization
    |> where([o], o.is_active==true)
    |> Repo.get!(id)

  end

  @doc """
  Creates a organization.

  ## Examples

      iex> create_organization(%{field: value})
      {:ok, %Organization{}}

      iex> create_organization(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
    |> handle_repo_result("Unable to create the organization.")
  end

  @doc """
  Updates a organization.

  ## Examples

      iex> update_organization(organization, %{field: new_value})
      {:ok, %Organization{}}

      iex> update_organization(organization, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
    |> handle_repo_result("Unable to update the organization.")
  end

  @doc """
  Soft deletes an organization by changing the value of is_active to false.

  ## Examples

      iex> delete_organization(organization)
      {:ok, %Organization{}}

      iex> delete_organization(organization)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organization(%Organization{} = organization) do
    organization
    |> Ecto.Changeset.change(%{is_active: false})
    |> Repo.update()
    |> handle_repo_result("Unable to delete the organization.")
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization changes.

  ## Examples

      iex> change_organization(organization)
      %Ecto.Changeset{data: %Organization{}}

  """
  def change_organization(%Organization{} = organization, attrs \\ %{}) do
    Organization.changeset(organization, attrs)
  end

end

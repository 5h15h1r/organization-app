defmodule OrganizationApi.OrganizationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OrganizationApi.Organizations` context.
  """

  @doc """
  Generate a organization.
  """
  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(%{
        configurations: %{},
        logo_url: "some logo_url",
        name: "some name"
      })
      |> OrganizationApi.Organizations.create_organization()

    organization
  end
end

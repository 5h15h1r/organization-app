defmodule OrganizationApi.Vendors.Vendor do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "vendors" do
    field :name, :string
    field :phone, :string
    field :email, :string
    belongs_to :organization, OrganizationApi.Organizations.Organization

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(vendor, attrs) do
    vendor
    |> cast(attrs, [:name, :phone, :email, :organization_id])
    |> validate_required([:name, :organization_id])
    |> unique_constraint(:name)
    |> assoc_constraint(:organization)
  end
end

defmodule OrganizationApi.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "organizations" do
    field :name, :string
    field :logo_url, :string
    field :configurations, :map
    field :deleted_at, :utc_datetime
    has_many :vendors , OrganizationApi.Vendors.Vendor
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :logo_url, :configurations])
    |> validate_required([:name, :logo_url])
  end
end

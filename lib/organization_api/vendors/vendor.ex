defmodule OrganizationApi.Vendors.Vendor do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "vendors" do
    field :name, :string
    field :phone, :string
    field :email, :string
    field :organization_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(vendor, attrs) do
    vendor
    |> cast(attrs, [:name, :phone, :email])
    |> validate_required([:name, :phone, :email])
    |> unique_constraint(:name)
  end
end

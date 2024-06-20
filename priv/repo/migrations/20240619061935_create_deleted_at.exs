defmodule OrganizationApi.Repo.Migrations.CreateDeletedAt do
  use Ecto.Migration

  def change do
    
    alter table(:organizations) do
      add :deleted_at, :utc_datetime
    end

    alter table(:vendors) do
      add :deleted_at, :utc_datetime
    end

  end
end

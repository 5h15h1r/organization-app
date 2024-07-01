defmodule OrganizationApiWeb.Router do
  use OrganizationApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", OrganizationApiWeb do
    pipe_through :api
    resources "/organizations", OrganizationController, except: [:new, :edit]
    resources "/vendors", VendorController, except: [:new, :edit]

    get "/auditlogs", AuditLogController, :index
    get "/auditlogs/table/:table_name", AuditLogController, :filter_by_table
    get "/auditlogs/action/:action", AuditLogController, :filter_by_action
  end
end

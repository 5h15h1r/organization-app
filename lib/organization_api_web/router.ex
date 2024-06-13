defmodule OrganizationApiWeb.Router do
  use OrganizationApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", OrganizationApiWeb do
    pipe_through :api
    resources "/organizations", OrganizationController, except: [:new, :edit]
  end
end

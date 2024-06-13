defmodule OrganizationApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OrganizationApiWeb.Telemetry,
      OrganizationApi.Repo,
      {DNSCluster, query: Application.get_env(:organization_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: OrganizationApi.PubSub},
      # Start a worker by calling: OrganizationApi.Worker.start_link(arg)
      # {OrganizationApi.Worker, arg},
      # Start to serve requests, typically the last entry
      OrganizationApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OrganizationApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OrganizationApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

# test/organization_api/workers/audit_log_worker_test.exs
defmodule OrganizationApi.Workers.AuditLogWorkerTest do
  use OrganizationApi.DataCase
  use Oban.Testing, repo: OrganizationApi.Repo

  alias OrganizationApi.Workers.AuditLogWorker
  alias OrganizationApi.AuditLogs.AuditLog
  import OrganizationApi.OrganizationsFixtures

  setup do
    org = organization_fixture()
    %{org: org}
  end

  describe "Oban Test" do
    test "creates an audit log successfully", %{org: org} do
      args = create_args(org)

      assert {:ok, %AuditLog{} = audit_log} = perform_job(AuditLogWorker, args)

      assert audit_log != nil
      assert audit_log.table_name == "organizations"
      assert audit_log.action == :create
      assert audit_log.record_id == org.id
      assert audit_log.new_data == %{"name" => "some name", "logo_url" => "some logo_url"}
      assert audit_log.old_data == nil
      assert audit_log.ip_address == "127.0.0.1"
      assert audit_log.user_agent == "Test Agent"
    end

    test "checks if an audit log job is enqueued", %{org: org} do
      args = create_args(org)

      assert {:ok, _job} = AuditLogWorker.new(args) |> Oban.insert()

      # Assert that a job with matching fields is enqueued.
      assert_enqueued(
        worker: AuditLogWorker,
        args: %{
          organization_id: org.id,
          table_name: "organizations",
          record_id: org.id,
          action: "create",
          user_agent: "Test Agent",
          ip_address: "127.0.0.1"
        }
      )
    end
    
    test "does not enqueue an audit log job when an error occurs during job insertion" do
      invalid_args = %{
        organization_id: 123
      }
      assert {:error, %Ecto.Changeset{}} = perform_job(AuditLogWorker, invalid_args)

      # Refute that a job with particular options has been enqueued.
      refute_enqueued(worker: AuditLogWorker, args: %{organization_id: 123})
    end
  end

  defp create_args(org) do
    %{
      organization_id: org.id,
      table_name: "organizations",
      action: "create",
      record_id: org.id,
      new_data: %{name: org.name, logo_url: org.logo_url},
      old_data: "",
      ip_address: "127.0.0.1",
      user_agent: "Test Agent"
    }
  end
end

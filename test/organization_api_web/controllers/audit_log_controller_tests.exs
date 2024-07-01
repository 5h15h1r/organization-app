defmodule OrganizationApiWeb.AuditLogControllerTest do
  use OrganizationApiWeb.ConnCase

  import OrganizationApi.AuditLogFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all audit logs", %{conn: conn} do
      conn = get(conn, ~p"/api/audit_logs")
      assert json_response(conn, 200) == []
    end
  end

  describe "filter_by_table" do
    test "lists audit logs filtered by table name", %{conn: conn} do
      audit_log1 = audit_log_fixture()

      conn = get(conn, ~p"/api/audit_logs/filter_by_table/organization")
      assert json_response(conn, 200) |> Enum.map(& &1["id"]) == [audit_log1.id]
    end
  end

  describe "filter_by_action" do
    test "lists audit logs filtered by action", %{conn: conn} do
      audit_log1 = audit_log_fixture(%{action: "create"})
      conn = get(conn, ~p"/api/audit_logs/filter_by_action/create")
      assert json_response(conn, 200)  == [audit_log1.id]
    end
  end
end

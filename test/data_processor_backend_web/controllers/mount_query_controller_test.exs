defmodule DataProcessorBackendWeb.MountQueryControllerTest do
  use DataProcessorBackendWeb.ConnCase

  alias DataProcessorBackend.InterSCity.JobTemplate
  alias DataProcessorBackend.InterSCity.JobScript
  alias DataProcessorBackend.InterSCity.ScriptSamples.SqlQuery

  setup %{conn: conn} do

    attrs = %{
      title: "Query SQL",
      language: "python",
      code: "abc",
      path: "sql_query.py",
      code_strategy: "Abc",
      defined_at_runtime: :false}
    {:ok, _script} = attrs |> JobScript.create()

    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe ":mount" do
    test "correctly mounts a new job_script", %{conn: conn} do
      data = %{
        "capability" => "city_traffic",
        "fileformat" => "json",
        "filename" => "myfile",
        "query" => "select * from city_traffic"
      }
      old_count = JobTemplate.count
      _conn = post(conn, Routes.mount_query_path(conn, :mount, data))
      new_count = JobTemplate.count

      assert old_count==new_count-1
    end
  end
end

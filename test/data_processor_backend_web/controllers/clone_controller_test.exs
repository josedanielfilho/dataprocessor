defmodule DataProcessorBackendWeb.CloneControllerTest do
  use DataProcessorBackendWeb.ConnCase

  import DataProcessorBackend.Factory

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobTemplate

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe ":clone" do
    test "correctly clones a new job_template", %{conn: conn} do
      template = insert(:job_template)
      conn = post(conn, Routes.job_template_clone_path(conn, :clone, template.id))
      resp = json_response(conn, 200)
      clone_id = resp["data"]["id"]
      refetched_clone = Repo.get!(JobTemplate, clone_id)
      assert refetched_clone.title==template.title
    end
  end
end

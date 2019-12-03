defmodule DataProcessorBackendWeb.ProcessingJobControllerTest do
  use DataProcessorBackendWeb.ConnCase

  import DataProcessorBackend.Factory



  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe ":index" do
    test "index lists processing jobs", %{conn: conn} do
      _job_script = insert(:processing_job)

      conn = get conn, Routes.processing_job_path(conn, :index)

      assert json_response(conn, 200)
      assert length(json_response(conn, 200)["data"])==1
    end
  end

  describe ":show" do
    test "correctly show existing processin job", %{conn: conn} do
      job = insert(:processing_job)

      conn = get conn, Routes.processing_job_path(conn, :show, job.id)

      assert json_response(conn, 200)
    end
  end
end

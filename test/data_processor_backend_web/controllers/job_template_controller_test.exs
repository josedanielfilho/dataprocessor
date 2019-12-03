defmodule DataProcessorBackendWeb.JobTemplateControllerTest do
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

  describe ":index" do
    test "index lists job_templates", %{conn: conn} do
      insert(:job_template)

      conn = get conn, Routes.job_template_path(conn, :index)

      assert json_response(conn, 200)
    end
  end

  describe ":create" do
    test "correctly creates a new job_template", %{conn: conn} do
      params = Poison.encode!(%{data: %{attributes: params_with_assocs(:job_template)}})
      conn = post(conn, Routes.job_template_path(conn, :create), params)
      assert json_response(conn, 201)
    end
  end

  describe ":update" do
    test "correctly creates a new job_template", %{conn: conn} do
      template = insert(:job_template)
      params = %{"attributes" => %{"title" => "newtemplatetitle"}, "id" => template.id}
      _conn = patch(conn, Routes.job_template_path(conn, :update, template.id), %{"data" => params})
      updated_template = Repo.get!(JobTemplate, template.id)
      assert updated_template.title != template.title
    end

    test "correctly updates query strings", %{conn: conn} do
      template = insert(:job_template)
      template = Repo.get!(JobTemplate, template.id)

      old_query = template.user_params |> Map.get("interscity") |> Map.get("sql_query")
      assert old_query == "select * all"
      params = %{"attributes" => %{"title" => "updated", "user_params" => %{"interscity" => %{"sql_query" => "hi all"}}}, "id" => template.id}
      _conn = patch(conn, Routes.job_template_path(conn, :update, template.id), %{"data" => params})
      updated_template = Repo.get!(JobTemplate, template.id)
      new_query = updated_template.user_params  |> Map.get("interscity") |> Map.get("sql_query")
      assert new_query == "hi all"
    end
  end
end

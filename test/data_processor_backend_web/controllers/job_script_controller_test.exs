defmodule DataProcessorBackendWeb.JobScriptControllerTest do
  use DataProcessorBackendWeb.ConnCase

  import DataProcessorBackend.Factory

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobScript

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe ":index" do
    test "index lists scripts", %{conn: conn} do
      _job_script = insert(:job_script)

      conn = get conn, Routes.job_script_path(conn, :index)

      assert json_response(conn, 200)
    end
  end

  describe ":create" do
    test "correctly creates scripts", %{conn: conn} do
      params = Poison.encode!(%{data: %{attributes: params_for(:job_script)}})
      conn = post(conn, Routes.job_script_path(conn, :create), params)
      assert json_response(conn, 201)
    end

    test "correctly generates non_runtime code", %{conn: conn} do
      params = Poison.encode!(%{data: %{attributes: params_for(:job_script)}})
      conn = post(conn, Routes.job_script_path(conn, :create), params)
      jobscript = json_response(conn, 201)
             |> Map.get("data")
             |> Map.get("id")
             |> JobScript.find

      assert jobscript.code=="blalb"
    end

    test "correctly generates runtime code", %{conn: conn} do
      strategy_module = DataProcessorBackend.InterSCity.ScriptSamples.SqlQuery
                    |> to_string

      myparams = %{
        title: "SQLScript",
        language: "python",
        path: "spark_jobs/python/kmeans.py",
        defined_at_runtime: true,
        code_strategy: strategy_module,
        code: "hello"
      }

      params = Poison.encode!(%{data: %{attributes: myparams}})
      conn = post(conn, Routes.job_script_path(conn, :create), params)

      jobscript = json_response(conn, 201)
             |> Map.get("data")
             |> Map.get("id")
             |> JobScript.find

      module = :"#{jobscript.code_strategy}"
      code = apply(module, :gen_code, [])
      assert code=~"spark.sql"
      assert jobscript.code=~"spark.sql"
    end
  end

  describe ":update" do
    test "correctly update scripts", %{conn: conn} do
      script = insert(:job_script)
      assert script.defined_at_runtime==false
      params = %{"attributes" => %{"title" => "newtitle"}, "id" => script.id}
      _conn = patch(conn, Routes.job_script_path(conn, :update, script.id), %{"data" => params})
      updated_script = Repo.get!(JobScript, script.id)
      assert updated_script.title != script.title
    end
  end
end

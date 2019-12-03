defmodule DataProcessorBackendWeb.ScriptStrategyControllerTest do
  use DataProcessorBackendWeb.ConnCase

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe ":index" do
    test "correctly list strategies", %{conn: conn} do
      conn = get(conn, Routes.script_strategy_path(conn, :index))
      resp = json_response(conn, 200)
      [first_strategy|_others]= resp["data"]
      strategy_name =
        first_strategy
        |> Map.get("attributes")
        |> Map.get("strategy-name")
      assert strategy_name=~"DataProcessorBackend"
    end
  end
end

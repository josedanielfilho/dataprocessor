defmodule DataProcessorBackend.InterSCity.ScriptSamples.SqlQueryTest do
  use DataProcessorBackend.DataCase
  alias DataProcessorBackend.InterSCity.ScriptSamples.SqlQuery

  describe ":gen" do
    test "work correctly" do
      assert SqlQuery.gen_code()=~"df ="
      assert SqlQuery.gen_code()=~".sql"
    end
  end

  describe ":discover_schema" do
    test "work correctly" do
      sch = SqlQuery.discover_schema("city_traffic")
      assert Map.has_key?(sch, "tick")
      assert Map.has_key?(sch, "nodeID")
      assert Map.has_key?(sch, "uuid")
      assert Map.has_key?(sch, "capability")
    end
  end
end

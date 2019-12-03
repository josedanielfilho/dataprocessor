defmodule DataProcessorBackend.InterSCity.ScriptSamples.SqlQuery do
  alias DataProcessorBackend.InterSCity.ScriptSamples.CodeGen
  use DataProcessorBackend.InterSCity.ScriptSamples.CodeGen

  def gen_operation do
    """
    \    df.createOrReplaceTempView(capability)
    \    queries = params["interscity"]["sql_queries"]
    \    if (isinstance(queries, list)):
    \        for q in queries:
    \            df = spark.sql(q)
    \    else:
    \        qq = queries.split(";")
    \        for q in qq:
    \            if (q):
    \                if (q == ''):
    \                    continue
    \                else:
    \                    df = spark.sql(q)
    """
  end

  def default_params(capability, query)do
    %{
      "schema" => discover_schema(capability),
      "functional" => %{},
      "interscity" => %{
        "capability" => capability,
        "sql_queries" => String.split(query, ";")
      }
    }
  end
end

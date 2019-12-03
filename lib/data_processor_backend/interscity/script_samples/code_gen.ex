defmodule DataProcessorBackend.InterSCity.ScriptSamples.CodeGen do
  defmacro __using__(_opts) do
    quote do
      def mongodb_url do
        "mongodb://#{System.get_env("DATA_COLLECTOR_MONGO")}/data_collector_development"
      end

      def _parse_sch({k, v}, acc) do
        cond do
          is_integer(v) ->
            Map.put(acc, k, "int")
          is_binary(v) ->
            Map.put(acc, k, "string")
          is_float(v) ->
            Map.put(acc, k, "double")
          true ->
            acc
        end
      end
      def _parse_sch(), do: %{}

      def discover_schema(capability) do
        {:ok, conn} = Mongo.start_link(url: mongodb_url())

        lists = conn
                 |> Mongo.find("sensor_values", %{"capability" => capability}, [limit: 1])
                 |> Enum.to_list
        h =
          case lists do
            [] -> []
            [h|_t] -> h
            _ -> :ok
          end

        Enum.reduce(h, %{}, fn ele, acc -> _parse_sch(ele, acc) end)
      end

      def headers_commons do
        """
        from pyspark.sql.types import *
        from pyspark.sql import SparkSession
        from pyspark import SparkContext, SparkConf
        import requests
        import os
        import sys
        """
      end

      def request_template do
        """
        \    my_uuid = str(sys.argv[1])
        \    os.environ['PYSPARK_PYTHON'] = '/usr/bin/python3'
        \    url = "#{DataProcessorBackendWeb.Endpoint.url}" + '/api/job_templates/{0}'.format(my_uuid)
        \    response = requests.get(url)
        \    params = response.json()["data"]["attributes"]["user-params"]
        \    publish_strategy = response.json()["data"]["attributes"]["publish-strategy"]
        \    capability = params["interscity"]["capability"]
        \    pipeline = "{'$match': {'capability': '"+capability+"'}}"
        """
      end

      def footer_commons do
        """
        \    fileformat = publish_strategy["format"]
        \    filepath = publish_strategy["path"]
        \    df.write.format(fileformat).mode("overwrite").save("/tmp/"+filepath+"."+fileformat)
        \    spark.stop()
        \    sc.stop()
        """
      end

      def spark_config do
        """
        \    MASTER_URL = "#{System.get_env("SPARK_MASTER")}"
        \    conf = (SparkConf()
        \     .set("spark.driver.bindAddress", "127.0.0.1")
        \     .set("spark.eventLog.enabled", "true")
        \     .set("spark.history.fs.logDirectory", "/tmp/spark-events")
        \     .set("spark.jars.packages", "org.mongodb.spark:mongo-spark-connector_2.11:2.4.0")
        \     .setMaster(MASTER_URL))
        \    sc = SparkContext(conf=conf)
        \    spark = SparkSession(sc)
        \    spark.sparkContext.setLogLevel("INFO")
        """
      end

      def retrieve_collector_data do
        """
        \    DEFAULT_URI = "#{mongodb_url()}"
        \    DEFAULT_COLLECTION = "sensor_values"
        \    df = (spark
        \            .read
        \            .format("com.mongodb.spark.sql.DefaultSource")
        \            .option("spark.mongodb.input.uri", "{0}.{1}".format(DEFAULT_URI, DEFAULT_COLLECTION))
        \            .option("pipeline", pipeline)
        \            .schema(sch)
        \            .load())
        """
      end

      def mount_schema do
        """
        \    schema_params = params["schema"]
        \    sch = StructType()
        \    for k,v in schema_params.items():
        \        if (v=="string"):
        \            sch.add(k, StringType())
        \        elif (v=="double"):
        \            sch.add(k, DoubleType())
        \        elif (v=="integer"):
        \            sch.add(k, LongType())
        \        elif (v=="int"):
        \            sch.add(k, LongType())
        """
      end

      def gen_header() do
        """
        #{headers_commons()}
        if __name__ == '__main__':
        #{request_template()}
        #{spark_config()}
        """
      end

      def gen_operation(), do: ""

      def gen_footer() do
        """
        #{footer_commons()}
        """
      end

      def gen_body() do
        """
        #{mount_schema()}
        #{retrieve_collector_data()}
        """
      end

      def gen_code do
        """
        #{gen_header()}
        #{gen_body()}
        #{gen_operation()}
        #{gen_footer()}
        """
      end

      defoverridable [gen_header: 0, gen_operation: 0, gen_body: 0,
        gen_footer: 0, mount_schema: 0, retrieve_collector_data: 0,
        headers_commons: 0, request_template: 0, spark_config: 0]
    end
  end
end

defmodule DataProcessorBackend.InterSCity.ScriptSamples.DefaultStrategy do
  @behaviour DataProcessorBackend.InterSCity.ScriptSamples.Operation
  @behaviour DataProcessorBackend.InterSCity.ScriptSamples.Header
  use DataProcessorBackend.InterSCity.ScriptSamples.CodeGen

  def gen_operation do
    """
    """
  end

  def gen_header do
    """
    """
  end
end

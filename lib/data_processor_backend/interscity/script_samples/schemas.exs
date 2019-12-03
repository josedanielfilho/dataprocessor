defmodule DataProcessorBackend.InterSCity.ScriptSamples.Schemas do
  def code do
    """
from pyspark.sql.types import StructType, StructField, ArrayType, StringType, DoubleType, IntegerType, DateType
from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, col
from pyspark.ml.feature import VectorAssembler
import requests
from pyspark import SparkContext, SparkConf
import os

import sys

if __name__ == '__main__':
\    os.environ['PYSPARK_PYTHON'] = '/usr/bin/python3'
\    # Loading the dataset
\    my_uuid = str(sys.argv[1])

\    url = "#{DataProcessorBackendWeb.Endpoint.url}" + '/api/job_templates/{0}'.format(my_uuid)
\    response = requests.get(url)
\    params = response.json()["data"]["attributes"]["user-params"]

\    functional_params = params["functional"]
\    capability = params["interscity"]["capability"]

\    features = list(map(lambda a: a.strip(), functional_params["features"].split(",")))
\    MASTER_URL = "#{System.get_env("SPARK_MASTER")}"
\    conf = (SparkConf()
\     .set("spark.eventLog.enabled", "true")
\     .set("spark.history.fs.logDirectory", "/tmp/spark-events")
\     .set("spark.app.name", "step2-datacollector-extraction(dataprocessor)")
\     .set("spark.jars.packages", "org.mongodb.spark:mongo-spark-connector_2.11:2.4.0")
\     .setMaster(MASTER_URL))
\    sc = SparkContext(conf=conf)
\    spark = SparkSession(sc)
\    spark.sparkContext.setLogLevel("INFO")
\    DEFAULT_URI = "mongodb://#{System.get_env("DATA_COLLECTOR_MONGO")}/data_collector_development"
\    DEFAULT_COLLECTION = "sensor_values"
\    pipeline = "{'$match': {'capability': '"+capability+"'}}"
\    schema_params = params["schema"]
\    sch = StructType()
\    sch.add("uuid", StringType())
\    for k,v in schema_params.items():
\        if (k=="string"):
\            sch.add(k, StringType())
\        elif (k=="double"):
\            sch.add(k, DoubleType())
\        elif (k=="integer"):
\            sch.add(k, LongType())
\    df = (spark
\            .read
\            .format("com.mongodb.spark.sql.DefaultSource")
\            .option("spark.mongodb.input.uri", "{0}.{1}".format(DEFAULT_URI, DEFAULT_COLLECTION))
\            .option("pipeline", pipeline)
\            .schema(sch)
\            .load())

\    spark.stop()
\    sc.stop()
    """
  end

  def common_schemas do
    [
      %{
        title: "InterSCSimulator Traffic Data",
        schema: %{
          nodeID: "int",
          uuid: "string",
          tick: "int"
        },
        capability: "traffic_data"
      },
      %{
        title: "Sensor Data",
        schema: %{
          measure: "double"
        },
        capability: "temperature"
      }
    ]
  end

  def language do
    "python"
  end

  def build_op(sch) do
    %{
      schema: sch[:schema],
      functional: %{},
      interscity: %{
        capability: sch[:capability]
      }
    }
  end
end

defmodule DataProcessorBackend.InterSCity.ScriptSamples.CollectorSource do
  def code do
    """
from pyspark.sql.types import StructType, StructField, ArrayType, StringType, DoubleType, IntegerType, DateType
from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, col
import requests
import os
from pyspark import SparkContext, SparkConf

import sys

if __name__ == '__main__':
\    # Loading the dataset
\    my_uuid = str(sys.argv[1])
\    os.environ['PYSPARK_PYTHON'] = '/usr/bin/python3'
\    url = "#{DataProcessorBackendWeb.Endpoint.url}" + '/api/job_templates/{0}'.format(my_uuid)
\    response = requests.get(url)
\    params = response.json()["data"]["attributes"]["user-params"]

\    functional_params = params["functional"]
\    capability = params["interscity"]["capability"]
\    pipeline = "{'$match': {'capability': '"+capability+"'}}"
\    if (params["interscity"]["limit"]):
\        u = str(int(params["interscity"]["limit"]))
\        pipeline = "[{'$match': {'capability': '"+capability+"'}}, {'$limit': "+u+"}]"
\    appname = params["interscity"]["appname"]
\    MASTER_URL = "#{System.get_env("SPARK_MASTER")}"
\    conf = (SparkConf()
\     .set("spark.eventLog.enabled", "true")
\     .set("spark.history.fs.logDirectory", "/tmp/spark-events")
\     .set("spark.app.name", appname)
\     .set("spark.jars.packages", "org.mongodb.spark:mongo-spark-connector_2.11:2.4.0")
\     .setMaster(MASTER_URL))
\    sc = SparkContext(conf=conf)
\    spark = SparkSession(sc)
\    spark.sparkContext.setLogLevel("INFO")

\    DEFAULT_URI = "mongodb://#{System.get_env("DATA_COLLECTOR_MONGO")}/data_collector_development"
\    DEFAULT_COLLECTION = "sensor_values"
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
\    publish_strategy = response.json()["data"]["attributes"]["publish-strategy"]
\    file_path = publish_strategy["path"]
\    (df
\     .write
\     .format(publish_strategy["format"])
\     .mode("overwrite")
\     .save("/tmp/" + file_path))
\    spark.stop()
    """
  end

  def example_title do
    """
    InterSCity Collector Data Gatherer
    """
  end

  def language do
    "python"
  end

  def example_user_params do
    %{
      schema: %{nodeID: "integer", tick: "integer", uuid: "string"},
      functional: %{},
      interscity: %{
        capability: "city_traffic",
        appname: "analysis1-dataprocessor-scenario0",
        limit: 33_466_742*0.01
      }
    }
  end
end

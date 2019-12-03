defmodule DataProcessorBackend.InterSCity.ScriptSamples.Kmeans do
  alias DataProcessorBackend.InterSCity.ScriptSamples.CodeGen
  use DataProcessorBackend.InterSCity.ScriptSamples.CodeGen

  alias DataProcessorBackend.InterSCity.ScriptSamples.Operation
  alias DataProcessorBackend.InterSCity.ScriptSamples.Headers
  @behaviour Operation
  @behaviour Headers

  def headers_commons do
    """
    from pyspark import SparkContext, SparkConf
    from pyspark.sql import SparkSession
    from pyspark.sql.types import StructType, StructField, ArrayType, StringType, DoubleType, IntegerType, DateType, LongType
    from pyspark.sql.functions import explode, col
    from pyspark.ml.feature import VectorAssembler
    from pyspark.ml.regression import LinearRegression
    from pyspark.ml.clustering import KMeans
    import requests
    import os
    import sys
    """
  end

  def gen_header do
    """
    #{headers_commons()}
    if __name__ == '__main__':
    #{request_template()}
    #{spark_config()}
    """
  end

  def gen_operation do
    """
    \    kmeans_params = params["functional"]
    \    features = list(map(lambda a: a.strip(), kmeans_params["features"].split(",")))
    \    assembler = VectorAssembler(inputCols=features, outputCol="features")
    \    assembled_df = assembler.transform(df).select("features")
    \    # Running KMeans
    \    how_many_clusters = int(kmeans_params.get("k", 2))
    \    seed_to_use = kmeans_params.get("seed", 1)
    \    kmeans = KMeans().setK(how_many_clusters).setSeed(seed_to_use)
    \    model = kmeans.fit(assembled_df)
    \    model_file_path = publish_strategy["path"]
    \    df = model
    \    centers = []
    \    for k in model.clusterCenters():
    \        centers.append(k.tolist())
    \    centers_df = spark.createDataFrame(centers, features)
    \    filepath = publish_strategy["path"]
    \    centers_df.write.format("parquet").mode("overwrite").save("/tmp/"+filepath + "_centers.parquet")
    """
  end

  def example_user_params do
    %{
      schema: %{temperature: "double"},
      functional: %{k: 3, features: "temperature"},
      interscity: %{capability: "temperature"}
    }
  end
end

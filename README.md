# DataProcessorBackend

## Installation

1. Make sure you have a working Elixir and Erlang. We are currently relying on
Erlang 20 and Elixir 1.7.0 but you will be in decent shape using newer
versions as well.
2. Install elixir dependencies: `mix deps.get`
3. Make sure you have a working Postgresql. These days we preffer to use Docker
and DockerCompose to host our Postgresql server but it is just for the
ease-to-setup. The command to run it is `docker-compose up -d data-processor-postgres`
4. Set the following environment variables if you are not using Docker:
```
      DATABASE_HOST: your_postgres_host (such as localhost)
      SPARK_SCRIPTS_PATH: path_to_store_spark_scripts (such as /opt/spark-utils/scripts)
      DATA_COLLECTOR_MONGO: host_running_datacollector_mongo (such as localhost or data-collector-mongo for Docker)
      SPARK_MASTER
```
5. Create and migrate your database with `mix ecto.setup`
6. Start Phoenix endpoint with `mix phx.server`. If you are using Docker/DockerCompose
you may use `docker-compose up -d data-processor-backend`
7. DataProcessor will be available at [`localhost:4005`](http://localhost:4005).
8. Also, make sure directory `/tmp/spark-events` exist.

## Using it

First of all, populate the database:
`MIX_ENV=dev mix run priv/repo/seeds.exs`


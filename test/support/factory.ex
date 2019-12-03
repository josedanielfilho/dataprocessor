defmodule DataProcessorBackend.Factory do
  use ExMachina.Ecto, repo: DataProcessorBackend.Repo

  alias DataProcessorBackend.InterSCity.JobTemplate
  alias DataProcessorBackend.InterSCity.JobScript
  alias DataProcessorBackend.InterSCity.ProcessingJob

  def job_template_factory do
    %JobTemplate{
      title: "KMeans Template",
      user_params: %{
        schema: %{temperature: "double"},
        interscity: %{capability: "city_traffic", sql_query: "select * all"}
      },
      publish_strategy: %{
        format: "csv"
      },
      job_script: build(:job_script),
      define_schema_at_runtime: false
    }
  end

  def job_script_factory do
    %JobScript{
      title: "KMeans script",
      code: "blalb",
      language: "python",
      path: "spark_jobs/python/kmeans.py",
      defined_at_runtime: false,
      code_strategy: "Elixir.DataProcessorBackend.InterSCity.ScriptSamples.SqlQuery"
    }
  end

  def processing_job_factory do
    %ProcessingJob{
      uuid: "abc-123",
      job_template: build(:job_template),
      job_state: "ready"
    }
  end
end

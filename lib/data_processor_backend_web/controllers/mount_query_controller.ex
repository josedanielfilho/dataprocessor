defmodule DataProcessorBackendWeb.MountQueryController do
  use DataProcessorBackendWeb, :controller

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.ScriptSamples.SqlQuery
  alias DataProcessorBackend.InterSCity.ProcessingJob
  alias DataProcessorBackend.InterSCity.JobTemplate
  alias DataProcessorBackend.InterSCity.JobScript
  alias DataProcessorBackendWeb.ProcessingJobView

  def mount(conn, %{"fileformat" => fileformat, "capability" => capability, "query" => query, "filename" => filename}) do
    script = Repo.get_by(JobScript, title: "Query SQL")

    publish_strategy = %{
      format: fileformat,
      path: filename
    }

    params = %{
      user_params: SqlQuery.default_params(capability, query),
      publish_strategy: publish_strategy,
      title: "#{capability} Query"
    }

    {:ok, template} = params |> JobTemplate.create(script)

    job = JobTemplate.schedule_job(template)

    conn
    |> put_view(ProcessingJobView)
    |> render("show.json-api", %{data: (job |> Repo.preload(:job_template))})
  end
end

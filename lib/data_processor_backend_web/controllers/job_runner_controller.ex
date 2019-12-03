defmodule DataProcessorBackendWeb.JobRunnerController do
  use DataProcessorBackendWeb, :controller

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.ProcessingJob
  alias DataProcessorBackend.InterSCity.JobTemplate
  alias DataProcessorBackendWeb.ProcessingJobView

  def run(conn, %{"processing_job_id" => job_id}) do
    processing_job = ProcessingJob.find!(job_id)
                     |> Repo.preload([{:job_template, [:job_script]}])
                     |> ProcessingJob.run

    conn
    |> put_view(ProcessingJobView)
    |> put_status(201)
    |> render("show.json-api", %{data: processing_job})
  end
end

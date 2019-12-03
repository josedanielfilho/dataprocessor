defmodule DataProcessorBackendWeb.CloneController do
  use DataProcessorBackendWeb, :controller

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobTemplate
  alias DataProcessorBackendWeb.JobTemplateView

  def clone(conn, %{"job_template_id" => template_id}) do
    new_template = JobTemplate.clone(template_id)

    conn
    |> put_view(JobTemplateView)
    |> render("show.json-api", %{data: new_template})
  end
end

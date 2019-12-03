defmodule DataProcessorBackendWeb.ProcessingJobController do
  use DataProcessorBackendWeb, :controller

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.ProcessingJob

  def index(conn, _params) do
    jobs = ProcessingJob.all() |> Repo.preload([{:job_template, [:job_script]}])

    conn
    |> render("index.json-api", %{data: jobs})
  end

  def show(conn, %{"id" => id}) do
    job = ProcessingJob.find!(id) |> Repo.preload([{:job_template, [:job_script]}])

    conn
    |> render("show.json-api", %{data: job})
  end

  def delete(conn, %{"id" => id}) do
    job = ProcessingJob.find!(id)
    case Repo.delete(job) do
      {:ok, _} ->
        conn
        |> put_status(201)
        |> render(:errors, data: [])
      {:error, reason} ->
        conn
        |> put_status(422)
        |> render(:errors, data: reason)
    end
  end
end

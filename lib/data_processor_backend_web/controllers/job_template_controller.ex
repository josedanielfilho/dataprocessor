defmodule DataProcessorBackendWeb.JobTemplateController do
  use DataProcessorBackendWeb, :controller

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobTemplate
  alias DataProcessorBackend.InterSCity.JobScript

  def index(conn, _params) do
    templates = JobTemplate.all() |> Repo.preload(:job_script)

    conn
    |> render("index.json-api", %{data: templates})
  end

  def create(conn, params) do
    attrs = JaSerializer.Params.to_attributes(params)
    script = JobScript.find!(attrs["job_script_id"])
    changeset = JobTemplate.changeset(%JobTemplate{job_script: script}, attrs)

    case Repo.insert(changeset) do
      {:ok, template} ->
        preloaded_template = template |> Repo.preload(:job_script)
        conn
        |> put_status(201)
        |> render("show.json-api", data: preloaded_template)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    template = JobTemplate.find!(id) |> Repo.preload(:job_script)

    conn
    |> render("show.json-api", data: template, opts: [include: "job_script"])
  end

  def update(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    template = JobTemplate.find!(Map.get(attrs, "id"))
    changeset = JobTemplate.changeset(template, attrs)

    case Repo.update(changeset) do
      {:ok, template} ->
        preloaded_template = template |> Repo.preload(:job_script)
        conn
        |> put_status(201)
        |> render("show.json-api", data: preloaded_template)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    template = JobTemplate.find!(id)
    case Repo.delete(template) do
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

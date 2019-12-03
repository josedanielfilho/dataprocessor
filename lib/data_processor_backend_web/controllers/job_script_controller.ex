defmodule DataProcessorBackendWeb.JobScriptController do
  use DataProcessorBackendWeb, :controller

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobScript

  def index(conn, _params) do
    scripts = JobScript.all

    conn
    |> render("index.json-api", %{data: scripts})
  end

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    IO.puts "[START] ATtrs:"
    IO.inspect attrs
    IO.puts "[END] aTTRS"
    changeset = JobScript.changeset(%JobScript{}, attrs)
    case Repo.insert(changeset) do
      {:ok, script} ->
        conn
        |> put_status(201)
        |> render("show.json-api", data: script)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    script = JobScript.find!(id)

    conn
    |> render("show.json", %{data: script})
  end

  def update(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    script = JobScript.find!(Map.get(attrs, "id"))
    changeset = JobScript.changeset(script, attrs)

    case Repo.update(changeset) do
      {:ok, script} ->
        conn
        |> put_status(201)
        |> render("show.json-api", data: script)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    script = JobScript.find!(id)
    case Repo.delete(script) do
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

defmodule DataProcessorBackendWeb.Router do
  use DataProcessorBackendWeb, :router

  pipeline :api do
    plug(:accepts, ["json-api", "json"])
    plug(JaSerializer.ContentTypeNegotiation)
    plug(JaSerializer.Deserializer)
    plug(CORSPlug, origin: "http://localhost:4200")
  end

  scope "/api", DataProcessorBackendWeb do
    pipe_through :api

    post("/mount_query_script", MountQueryController, :mount)

    resources("/script_strategies", ScriptStrategyController, only: [:index, :show])

    resources("/job_templates", JobTemplateController, only: [:index, :create, :show, :update, :delete]) do
      post("/clone", CloneController, :clone)
      post("/schedule", JobSchedulerController, :schedule)
    end

    resources("/job_scripts", JobScriptController, only: [:index, :create, :show, :update, :delete])

    resources("/processing_jobs", ProcessingJobController, only: [:index, :show, :delete]) do
      post("/run", JobRunnerController, :run)
    end
  end
end
